module EventStore
  module Client
    module StreamName
      extend self

      STREAM_ID_MATCHER = %r{(?<stream_id>#{Identifier::UUID::MATCHER})}

      def stream_name(category_name, id=nil, random: nil)
        id ||= Identifier::UUID.random
        random ||= false

        if random
          category_name = EventStore::Client::StreamName.random_category_name(category_name)
        end

        "#{category_name}-#{id}"
      end

      def category_stream_name(category_name)
        "$ce-#{category_name}"
      end

      def self.random_category_name(category_name)
        random_id = Identifier::UUID.random.gsub('-', '')
        "#{category_name}#{random_id}"
      end

      def self.get_id(stream_name)
        match = STREAM_ID_MATCHER.match(stream_name) or return
        match["stream_id"]
      end
    end
  end
end
