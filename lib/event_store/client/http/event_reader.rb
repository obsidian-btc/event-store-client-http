 module EventStore
  module Client
    module HTTP
      class EventReader
        dependency :request, EventStore::Client::HTTP::Request::Get
        dependency :logger, Telemetry::Logger

        # default slice_reader
        def self.build
          logger.trace "Building entry reader"

          new.tap do |instance|
            EventStore::Client::HTTP::Request::Get.configure instance
            Telemetry::Logger.configure instance
            logger.debug "Built entry reader"
          end
        end

        def each_event(raw_entries, &action)
          raw_entries.reverse_each do |raw_entry|
            entry = get_entry(raw_entry)
            action.call entry
          end
        end

        def get_entry(raw_entry)
          json_text = get_json_text(raw_entry)
          parse_entry(json_text)
        end

        def get_json_text(raw_entry)
          uri = entry_link(raw_entry)
          body_text, _ = request.! uri
          body_text
        end

        def parse_entry(json_text)
          EventData::Read.parse json_text
        end

        def entry_link(raw_entry)
          raw_entry['links'].map do |link|
            link['uri'] if link['relation'] == 'edit'
          end.compact.first
        end

        def deserialize_entry(raw_entry)
          raw_entry
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end
    end
  end
end
