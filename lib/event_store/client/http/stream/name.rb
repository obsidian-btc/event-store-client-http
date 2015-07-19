module EventStore
  module Client
    module HTTP
      module Stream
        module Name
          extend self

          def stream_name(category_name, id=nil, random: nil)
            id ||= UUID.random
            random ||= false

            if random
              category_name = EventStore::Client::HTTP::Stream::Name.random_category_name(category_name)
            end

            "#{category_name}-#{id}"
          end

          def category_stream_name(category_name)
            "$ce-#{category_name}"
          end

          def self.random_category_name(category_name)
            random_id = UUID.random.gsub('-', '')
            "#{category_name}#{random_id}"
          end

          def self.get_id(stream_name)
            id = stream_name.match(/[a-f0-9]{8}-[a-f0-9]{4}-4[a-f0-9]{3}-[89aAbB][a-f0-9]{3}-[a-f0-9]{12}/i).to_s
            id = nil if id == ''
            id
          end
        end
      end
    end
  end
end
