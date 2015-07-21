module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.extend Logger
          cls.extend Build
          cls.extend Configure

          cls.send :dependency, :logger, Telemetry::Logger
          cls.send :dependency, :client, EventStore::Client::HTTP::Client
        end

        module Build
          def build(client=nil)
            new(client).tap do |instance|
              Telemetry::Logger.configure instance
              instance.configure_client(client)
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

        def initialize(client)
          @client = client
        end

        def configure_client(client=nil)
          if client.nil?
            Client.configure self
          else
            self.client = client
          end
        end
      end
    end
  end
end
