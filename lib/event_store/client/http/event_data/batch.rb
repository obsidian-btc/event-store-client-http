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
                event_data = [event_data] unless event_data.is_a? Array
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

          module Serializer
            def self.json
              JSON
            end

            def self.raw_data(instance)
              instance.list.map do |event_data|
                Serialize::Write.raw_data event_data
              end
            end

            module JSON
              def self.serialize(data)
                formatted_data = Casing::Camel.(data)
                ::JSON.pretty_generate formatted_data
              end
            end
          end
        end
      end
    end
  end
end
