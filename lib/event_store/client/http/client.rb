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
          body = socket.read content_length

          [response, body]
        end

        def post(request, data)
          request["Content-Length"] = data.size

          response = self.! request do
            socket.write data
          end

          response
        end

        def !(request)
          request["Host"] = host

          socket.write request
          yield if block_given?

          builder = ::HTTP::Protocol::Response.builder
          builder << socket.gets until builder.finished_headers?
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
