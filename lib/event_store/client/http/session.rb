# Closed for further elaboration [Nathan, Scott, Wed Jan 27, 2016]
module EventStore
  module Client
    module HTTP
      class Session
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger
        dependency :connection, Connection::Client

        def self.build(settings=nil, namespace=nil)
          logger.trace "Building HTTP session"

          new.tap do |instance|
            Telemetry::Logger.configure instance

            settings ||= Settings.instance
            namespace = Array(namespace)

            settings.set(instance, *namespace)

            Connection::Client.configure instance, instance.host, instance.port, :reconnect => :when_closed

            logger.debug "Built HTTP session (Host: #{instance.host}, Port: #{instance.port})"
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

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
