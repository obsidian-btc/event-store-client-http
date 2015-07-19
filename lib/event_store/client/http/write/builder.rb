module EventStore
  module Client
    module HTTP
      module Vertx
        class Write
          class Request
            class Builder
              attr_reader :client
              attr_reader :path

              attr_accessor :content_type
              attr_accessor :expected_version

              dependency :body_handler_block
              dependency :exception_handler_block

              dependency :logger, Telemetry::Logger

              def initialize(client, path)
                @client = client
                @path = path
              end

              def self.build(client, path, expected_version=nil)
                new(client, path).tap do |instance|
                  Telemetry::Logger.configure instance

                  instance.expected_version = nil
                  instance.assign_event_store_media_type
                end
              end

              def assign_event_store_media_type
                 self.content_type = 'application/vnd.eventstore.events+json'
              end

              def exception_handler(&blk)
                self.exception_handler_block = blk
              end

              def body_handler(&blk)
                self.body_handler_block = blk
              end

              def request
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
  end
end
