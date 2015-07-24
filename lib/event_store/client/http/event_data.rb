module EventStore
  module Client
    module HTTP
      class EventData
        class IdentityError < RuntimeError; end

        include Schema::DataStructure

        dependency :uuid, UUID::Random
        dependency :logger, Telemetry::Logger

        attribute :type
        attribute :data
        attribute :metadata

        def configure_dependencies
          UUID::Random.configure self
          Telemetry::Logger.configure self
        end

        def digest
          "Type: #{type}"
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end
    end
  end
end
