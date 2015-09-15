module EventStore
  module Client
    module HTTP
      class Session
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger

        def self.build
          logger.trace "Building HTTP session"

          new.tap do |instance|
            Telemetry::Logger.configure instance
            Settings.instance.set(instance)
            logger.debug "Built HTTP session"
          end
        end

        def self.configure(receiver)
          session = build
          receiver.session = session
          session
        end

        def request(request, request_body: "", response_body: "")
          request.headers.merge! request_headers
          request["Content-Length"] = request_body.size

          logger.trace "Writing request to #{socket.inspect}"
          logger.data "Request headers:\n\n#{request}"

          socket.write request
          write_request_body request_body
          response = start_response
          content_length = response["Content-Length"].to_i
          read_response_body response_body, content_length

          socket.close if response["Connection"] == "close"

          response
        end

        def write_request_body(request_body)
          return if request_body.empty?
          logger.data "Writing data to #{socket}:\n\n#{request_body}"
          socket.write request_body
        end

        def start_response
          builder = ::HTTP::Protocol::Response.builder
          until builder.finished_headers?
            next_line = socket.gets
            logger.data "Read #{next_line.chomp}"
            builder << next_line
          end
          builder.message
        end

        def read_response_body(response_body, content_length)
          amount_read = 0
          while amount_read < content_length
            packet = socket.read content_length
            response_body << packet
            amount_read += packet.size
          end
        end

        def request_headers
          @request_headers ||=
            begin
              headers = ::HTTP::Protocol::Request::Headers.new
              headers["Host"] = host
              headers
            end
        end

        def connection
          @connection ||= Connection::Client.build host, port
        end
        alias_method :socket, :connection

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
