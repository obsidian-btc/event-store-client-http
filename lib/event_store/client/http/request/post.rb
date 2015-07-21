module EventStore
  module Client
    module HTTP
      module Request
        class Post
          attr_reader :client
          attr_reader :path

          attr_accessor :content_type
          attr_accessor :expected_version

          dependency :logger, Telemetry::Logger
          dependency :client, Faraday::Connection

          def initialize(path, client)
            @path = path
            @client = client
          end

          def self.build(path, client=nil)
            new(path, client).tap do |instance|
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

          def !(data)
            logger.debug "Posting to #{path}"
            logger.data data

            response = client.post do |request|
              request.body = data

              set_path(request)
              set_event_store_media_type_header(request)
            end

            logger.debug "-- RESPONSE: #{response.inspect}"

            logger.debug "POST Response\nPath: #{path}\nStatus: #{(response.status.to_s + " " + response.body).rstrip}"
          end

          def set_path(request)
            request.url path
          end

          def set_event_store_media_type_header(request)
             request.headers['Content-Type'] = 'application/vnd.eventstore.events+json'
          end

          def request__
            logger.trace "Constructing the POST request to #{path}"
            request = client.request('POST', path) do |response|
              response.body_handler do |body|
                logger.debug "POST Response\nPath: #{path}\nStatus: #{(response.status_code.to_s + " " + response.status_message).rstrip}"
                body_handler_block.call body
              end
            end

            request.exception_handler do |e|
              logger.error e.inspect
              exception_handler_block.call e
            end

            request.put_header('Content-Type', content_type)
            request.put_header("ES-ExpectedVersion", expected_version) if expected_version

            logger.debug "Constructed the POST request to #{path}"

            request
          end
        end
      end
    end
  end
end
