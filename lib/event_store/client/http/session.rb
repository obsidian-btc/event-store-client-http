module EventStore
  module Client
    module HTTP
      class Session
        setting :host
        setting :port

        attr_writer :connection

        dependency :logger, Telemetry::Logger

        def self.build(settings=nil, namespace=nil)
          logger.trace "Building HTTP session"

          new.tap do |instance|
            Telemetry::Logger.configure instance

            settings ||= Settings.instance
            namespace = Array(namespace)

            settings.set(instance, *namespace)
            logger.debug "Built HTTP session"
          end
        end

        def self.configure(receiver)
          session = build
          receiver.session = session
          session
        end

        def build_uri(path)
          uri = URI(path)

          if uri.absolute?
            uri
          else
            URI::HTTP.build(
              :host => host,
              :port => port,
              :path => path
            )
          end
        end

        def connection
          @connection ||= Connection.client host, port
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
