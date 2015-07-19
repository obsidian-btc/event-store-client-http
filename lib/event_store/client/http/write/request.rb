module EventStore
  module Client
    module HTTP
      module Vertx
        class Write
          class Request
            attr_reader :stream_name

            dependency :client
            dependency :logger, Telemetry::Logger

            def initialize(stream_name)
              @stream_name = stream_name
            end

            def self.build(stream_name, client)
              logger.trace "Building request (Stream Name: #{stream_name}, Client: #{client.inspect}"
              new(stream_name).tap do |instance|
                Telemetry::Logger.configure instance
                instance.client = client
                logger.debug "Built request (Stream Name: #{stream_name}, Client: #{client.inspect}"
              end
            end

            def self.configure(receiver, stream_name, client)
              instance = build(stream_name, client)
              receiver.request = instance
            end

            def !(json_text, expected_version: nil)
              logger.trace "Executing request (Stream Name: #{stream_name})"

              request = build_request(expected_version: expected_version)
              post(json_text, request)

              logger.info "Executed request (Stream Name: #{stream_name})"
              logger.data "Data: #{json_text}, Expected Version: #{expected_version}"
            end

            def post(json_text, request)
              request.put_header('Content-Length', json_text.length)
              request.write_str(json_text)
              request.end
            end

            def build_request(expected_version: nil)
              logger.trace "Composing request (Path: #{path})"

              builder = Builder.build client, path, expected_version

              builder.request.tap do
                logger.debug "Composed request (Path: #{path})"
              end
            end

            def path
              "/streams/#{stream_name}"
            end

            def self.logger
              @logger ||= Telemetry::Logger.get self
            end
          end
        end
      end
    end
  end
end
