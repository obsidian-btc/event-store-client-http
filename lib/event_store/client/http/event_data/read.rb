module EventStore
  module Client
    module HTTP
      class EventData
        class Read < EventData
          attribute :number
          attribute :position
          attribute :stream_name
          attribute :created_time
          attribute :links

          module Serializer
            def self.json
              JSON
            end

            class Links
              include Schema::DataStructure

              attribute :edit_uri
            end

            def self.instance(raw_data)
              content = raw_data[:content] || {}

              links = Links.new

              raw_data[:links].to_a.each do |link_data|
                links.edit_uri = link_data[:uri] if link_data[:relation] == 'edit'
              end

              instance = Read.build(
                :created_time => raw_data[:updated],
                :data => content[:data],
                :links => links,
                :number => content[:event_number],
                :stream_name => content[:event_stream_id],
                :type => content[:event_type]
              )

              unless content[:metadata] == ''
                instance.metadata = content[:metadata]
              end

              instance
            end

            module JSON
              def self.deserialize(text)
                raw_data = ::JSON.parse text, :symbolize_names => true
                Casing::Underscore.(raw_data)
              end
            end
          end
        end
      end
    end
  end
end
