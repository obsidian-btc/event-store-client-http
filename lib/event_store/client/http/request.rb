module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.extend Logger
          cls.extend Build
          cls.extend Configure

          cls.send :dependency, :logger, Telemetry::Logger
          cls.send :dependency, :session, EventStore::Client::HTTP::Session
        end

        module Build
          def build(session=nil)
            new(session).tap do |instance|
              Telemetry::Logger.configure instance
              instance.configure_session(session)
            end
          end
        end

        module Configure
          def configure(receiver, attr_name=nil)
            attr_name ||= :request

            logger.trace "Configuring request (Receiver: #{receiver})"
            request = build
            receiver.send "#{attr_name}=", request
            logger.debug "Configured request (Receiver: #{receiver})"

            request
          end
        end

        module Logger
          def logger
            Telemetry::Logger.get self
          end
        end

        def initialize(session)
          @session = session
        end

        def configure_session(session=nil)
          if session.nil?
            Session.configure self
          else
            self.session = session
          end
        end
      end
    end
  end
end
