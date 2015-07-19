module EventStore
  module Client
    module HTTP
      module Vertx
        class ClientBuilder
          def self.configure_client(receiver)
            logger = logger()

            logger.trace "Configuring client (Receiver: #{receiver})"
            client = build_client
            receiver.client = client
            logger.debug "Configured client (Receiver: #{receiver})"

            client
          end

          def self.build_client
            logger.trace "Building Vert.x HTTP client"
            ::Vertx::HttpClient.new.tap do |client|
              Settings.instance.set(client, strict: false)
              logger.trace "Built Vert.x HTTP client"
            end
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
