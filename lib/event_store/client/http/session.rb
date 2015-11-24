module EventStore
  module Client
    module HTTP
      class Session
        setting :host
        setting :port

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

        def get(request)
          response_body = ""

          headers = request_headers
          request.headers.merge! headers

          start_request(request)

          response = start_response
          content_length = response["Content-Length"].to_i
          read_response_body response_body, content_length

          connection.close if response["Connection"] == "close"

          return response_body, response
        end

        def post(request, request_body)
          headers = request_headers request_body.bytesize
          request.headers.merge! headers

          start_request(request)

          logger.trace "Posting (Content Length: #{request_body.size})"
          logger.data request_body
          connection.write request_body
          logger.debug "Posted (Content Length: #{request_body.size})"

          response = start_response

          connection.close if response["Connection"] == "close"

          response
        end

        def start_request(request)
          logger.trace "Transmitting request (Connection: #{connection.inspect})"
          logger.data request
          connection.write request
          logger.debug "Transmitted request (Connection: #{connection.inspect})"
        end

        def start_response
          builder = ::HTTP::Protocol::Response::Builder.build
          until builder.finished_headers?
            next_line = connection.gets
            logger.data "Read #{next_line.chomp}"
            builder << next_line
          end
          builder.message
        end

        def read_response_body(response_body, content_length)
          amount_read = 0
          while amount_read < content_length
            packet = connection.read content_length
            response_body << packet
            amount_read += packet.size
          end
        end

        def request_headers(content_length=nil)
          headers = ::HTTP::Protocol::Request::Headers.build
          headers["Host"] = host
          headers["Content-Length"] = content_length if content_length
          headers
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
