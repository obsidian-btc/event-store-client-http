module EventStore
  module Client
    module HTTP
      class Client
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger

        attr_writer :socket

        def self.build
          logger.debug "Building HTTP client"

          new.tap do |instance|
            Telemetry::Logger.configure instance
            Settings.instance.set(instance)
            logger.trace "Built HTTP client"
          end
        end

        def self.configure(receiver)
          logger.trace "Configuring client (Receiver: #{receiver})"
          client = build
          receiver.client = client
          logger.debug "Configured client (Receiver: #{receiver})"

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

          [response, body]

        ensure
          socket.close if response["Connection"] == "close"
        end

        def post(request, data)
          request["Content-Length"] = data.size

          response = self.! request do
            socket.write data
          end

          response

        ensure
          socket.close if response["Connection"] == "close"
        end

        def !(request)
          request["Host"] = host

          logger.data "Writing request to #{socket}:\n\n#{request}"
          socket.write request
          yield if block_given?

          builder = ::HTTP::Protocol::Response.builder
          until builder.finished_headers?
            next_line = socket.gets
            logger.data "Read #{next_line.chomp}"
            builder << next_line
          end
          response = builder.message

          reset_socket if response["Connection"] == "close"

          response
        end

        def socket
          @socket ||= TCPSocket.new host, port
        end

        def reset_socket
          socket.close
          self.socket = nil
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
