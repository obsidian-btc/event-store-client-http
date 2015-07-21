module EventStore
  module Client
    module HTTP
      module Request
        class Get
          attr_accessor :path

          dependency :logger, Telemetry::Logger
          dependency :client, Net::HTTP

          def initialize(client)
            @client = client
          end

          def self.build(client=nil)
            new(client).tap do |instance|
              Telemetry::Logger.configure instance
              instance.configure_client(client)
            end
          end

          def configure_client(client=nil)
            if client.nil?
              ClientBuilder.configure_client self
            else
              self.client = client
            end
          end

          def !(path)
            logger.debug "Getting from #{path}"

            response = get(path)
            body = response.body

            logger.debug "GET Response\nPath: #{path}\nStatus: #{(response.code + " " + response.message).rstrip}"
            logger.trace "Got from #{path}"

            logger.data body

            return body, response
          end

          def get(path)
            request = build_request(path)
            client.request(request)
          end

          def build_request(path)
            request = Net::HTTP::Get.new(path)

            set_event_store_accept_header(request)

            request
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end

          def set_event_store_accept_header(request)
            request['Accept'] = media_type
          end
        end
      end
    end
  end
end
