module EventStore
  module Client
    module HTTP
      class ClientBuilder
        class CacheLogger
          def self.logger
            @logger ||= Telemetry::Logger.get self
          end

          def self.instrument(instrument_name, payload)
            logger.trace "#{instrument_name}: #{payload}"
          end
        end

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

          Faraday.new.tap do |client|
            Settings.instance.set(client, strict: false)

            client.adapter :net_http
            # client.use :http_cache, instrumenter: CacheLogger
            client.use :http_cache

            logger.trace "Built HTTP client (Class: #{client.class.name})"
          end
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
