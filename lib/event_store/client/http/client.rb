module EventStore
  module Client
    module HTTP
      class Client
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger

        attr_writer :connector

        def self.build
          logger.debug "Building HTTP client"

          new.tap do |instance|
            Telemetry::Logger.configure instance
            Settings.instance.set(instance)
            logger.trace "Built HTTP client"
          end
        end

        def self.configure(receiver)
          client = build
          receiver.client = client
          client
        end

        def get(request)
          response = self.! request

          content_length = response["Content-Length"].to_i

          body = ""
          until body.size == content_length
            packet = socket.read content_length
            body << packet
          end

          close_socket if response["Connection"] == "close"

          return body, response
        end

        def post(request, data)
          request["Content-Length"] = data.size

          response = self.! request do
            logger.data "Writing data to #{socket}:\n\n#{data}"
            socket.write data
          end

          close_socket if response["Connection"] == "close"

          response
        end

        def !(request)
          request["Host"] = host

          logger.trace "Writing request to #{socket.inspect}"
          logger.data "Request headers:\n\n#{request}"
          socket.write request
          yield if block_given?

          builder = ::HTTP::Protocol::Response.builder
          until builder.finished_headers?
            next_line = socket.gets
            logger.data "Read #{next_line.chomp}"
            builder << next_line
          end
          response = builder.message

          response
        end

        def connector
          @connector or ->{connect}
        end

        def socket
          @socket ||= connector.()
        end

        def connect
          TCPSocket.new host, port
        end

        def close_socket
          socket.close
          @socket = nil
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
