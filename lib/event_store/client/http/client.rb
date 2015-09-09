module EventStore
  module Client
    module HTTP
      class Client
        setting :host
        setting :port

        dependency :logger, Telemetry::Logger

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
          request["Host"] = host
          socket = TCPSocket.new host, port
          socket.write request

          builder = ::HTTP::Protocol::Response.builder
          builder << socket.gets until builder.finished_headers?
          response = builder.message
          content_length = response["Content-Length"].to_i
          socket.close if response["Connection"] == "close"

          body = socket.read content_length
          [response, body]
        end

        def post(request, data)
          request["Host"] = host
          request["Content-Length"] = data.size
          socket = TCPSocket.new host, port
          socket.write request
          socket.write data

          builder = ::HTTP::Protocol::Response.builder
          builder << socket.gets until builder.finished_headers?
          response = builder.message
          socket.close if response["Connection"] == "close"

          response
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
