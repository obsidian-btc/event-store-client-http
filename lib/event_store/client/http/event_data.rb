module EventStore
  module Client
    module HTTP
      class EventData
        class IdentityError < RuntimeError; end

        include Schema::DataStructure

        dependency :uuid, UUID::Random
        dependency :logger, Telemetry::Logger

        attribute :id
        attribute :type
        attribute :data
        attribute :metadata

        def configure_dependencies
          UUID::Random.configure self
          Telemetry::Logger.configure self
        end

        def assign_id
          raise IdentityError, "ID is already assigned (ID: #{id})" unless id.nil?

          self.id = uuid.get
        end

        def serialize
          json_formatted_data.to_json
        end

        def json_formatted_data
          json_data = {
            'eventId' => id,
            'eventType' => type
          }

          json_data['data'] = Casing::Camel.!(data) if data
          json_data['metaData'] = Casing::Camel.!(metadata) if metadata

          json_data
        end

        def digest
          "Type: #{type}, ID: #{id}"
        end

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
