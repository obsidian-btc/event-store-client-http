module EventStore
  module Client
    module HTTP
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
          logger.trace "Building HTTP client"

          host = Settings.instance.get 'host'
          port = Settings.instance.get 'port'

          client = Net::HTTP.new(host, port).tap do
            logger.debug "Built HTTP client (Class: #{client.class.name})"
          end
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
