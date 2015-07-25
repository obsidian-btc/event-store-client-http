 module EventStore
  module Client
    module HTTP
      module Vertx
        class Writer
          dependency :client
          dependency :logger, Telemetry::Logger

          def self.configure(receiver)
            build.tap do |instance|
              receiver.writer = instance
            end
          end

          def self.build
            logger.trace "Building writer"

            new.tap do |instance|
              instance.configure_logger
              instance.configure_client
              logger.debug "Built writer"
            end
          end

          def configure_logger
            Telemetry::Logger.configure self
          end

          def configure_client
            ClientBuilder.configure_client self
          end

          def write(stream_name, event_data, expected_version: nil)
            logger.trace "Writing entry (Stream Name: #{stream_name})"

            Write.!(stream_name, event_data, expected_version: expected_version, client: client).tap do |instance|
              logger.debug "Wrote entry (Stream Name: #{stream_name})"
            end
          end

          def stream_name(id)
            "#{category_name}-#{id}"
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
