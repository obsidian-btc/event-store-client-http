module EventStore
  module Client
    module HTTP
      module Request
        def self.included(cls)
          cls.extend Build

          cls.send :dependency, :logger, Telemetry::Logger
          cls.send :dependency, :client, Net::HTTP
        end

        module Build
          def build(client=nil)
            new(client).tap do |instance|
              Telemetry::Logger.configure instance
              instance.configure_client(client)
            end
          end
        end

        def initialize(client)
          @client = client
        end

        def configure_client(client=nil)
          if client.nil?
            ClientBuilder.configure_client self
          else
            self.client = client
          end
        end
      end
    end
  end
end
