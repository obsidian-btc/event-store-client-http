module EventStore
  module Client
    module HTTP
      class EventData
        class Batch
          dependency :logger, Telemetry::Logger

          def self.build
            new.tap do |instance|
              Telemetry::Logger.configure instance
            end
          end

          def list
            @list ||= []
          end

          def add(event_data)
            list << event_data
          end

          def serialize
            json_formatted_data.to_json
          end

          def json_formatted_data
            list.map do |event_data|
              event_data.json_formatted_data
            end
          end
        end
      end
    end
  end
end
