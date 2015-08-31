module EventStore
  module Client
    module HTTP
      class Client
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger

        def self.build
          logger.debug "Building HTTP client"

          new.tap do |instance|
            Settings.instance.set(instance)
            logger.trace "Built HTTP client"
          end
        end

        def self.configure(receiver)
          logger.trace "Configuring client (Receiver: #{receiver})"
          client = build
          receiver.client = client
          logger.debug "Configured client (Receiver: #{receiver})"

          client
        end

        def client_instance
          unless @client_instance
            logger.trace "Building Net::HTTP instance (Host: #{host}, Port: #{port})"
            @client_instance = Net::HTTP.new(host, port)
            logger.debug "Built Net::HTTP instance (Host: #{host}, Port: #{port})"
          end

          @client_instance
        end

        def method_missing(method_name, *args, &block)
          client_instance.send method_name, *args, &block
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
