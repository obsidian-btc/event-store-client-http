module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.extend Logger
          cls.extend Build
          cls.extend Configure
          cls.extend Virtual::Macro

          cls.public_send :dependency, :logger, Telemetry::Logger
          cls.public_send :dependency, :session, EventStore::Client::HTTP::Session
          cls.public_send :virtual, :configure_dependencies
        end

        module Build
          def build(session: nil)
            new.tap do |instance|
              Telemetry::Logger.configure instance
              instance.configure_dependencies
              instance.configure_session(session)
            end
          end
        end

        module Configure
          def configure(receiver, attr_name=nil, session: nil)
            attr_name ||= :request
            request = build session: session
            receiver.send "#{attr_name}=", request

            request
          end
        end

        module Logger
          def logger
            Telemetry::Logger.get self
          end
        end

        def configure_session(session=nil)
          if session.nil?
            Session.configure self
          else
            self.session = session
          end
        end

        module Assertions
          def connection_scheduler?(scheduler)
            session.connection.scheduler == scheduler
          end
        end
      end
    end
  end
end
