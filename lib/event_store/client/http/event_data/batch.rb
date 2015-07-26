module EventStore
  module Client
    module HTTP
      class EventData
        class Batch
          dependency :logger, Telemetry::Logger

          def self.build(event_data=nil)



            new.tap do |instance|
              Telemetry::Logger.configure instance

              event_data = [event_data] unless event_data.is_a? Array

              if !!event_data
                instance.concat event_data
              end
            end
          end

          def list
            @list ||= []
          end

          def concat(event_data)
            list.concat event_data
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
