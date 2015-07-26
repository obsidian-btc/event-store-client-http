module EventStore
  module Client
    module HTTP
      class EventData
        class Batch
          dependency :logger, Telemetry::Logger

          def self.build(event_data=nil)



            new.tap do |instance|
              Telemetry::Logger.configure instance

              if !!event_data
                instance.add event_data
              end
            end
          end

          def list
            @list ||= []
          end

          def length
            list.length
          end

          def any?(event_data)
            list.include? event_data
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
