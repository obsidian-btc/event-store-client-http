 module EventStore
  module Client
    module HTTP
      module Vertx
        class Reader
          class Error < RuntimeError; end

          attr_accessor :stream_name
          attr_writer :starting_position
          attr_writer :slice_generator
          attr_reader :start_uri

          dependency :client
          dependency :logger, Telemetry::Logger

          def starting_position
            @starting_position ||= 0
          end

          def slice_size
            @slice_size ||= 20
          end

          def next?
            !!next_uri
          end

          def initialize(start_uri)
            @start_uri = start_uri
          end

          def self.build(stream_name, starting_position: nil, slice_size: nil)
            starting_position ||= 0
            slice_size ||= 20

            logger.trace "Building Reader (Stream Name: #{stream_name}, Position: #{starting_position})"

            start_uri = slice_path(stream_name, starting_position, slice_size)

            new(start_uri).tap do |instance|
              ClientBuilder.configure_client instance

              instance.client.keep_alive = true

              Telemetry::Logger.configure instance

              logger.debug "Built Reader (Stream Name: #{stream_name}, Position: #{starting_position})"
            end
          end

          def each(uri=nil, &ext_blk)
            AsyncInvocation.incorrect.each unless block_given?

            uri ||= start_uri

            logger.trace "Getting (URI: #{uri})"

            self.get(uri, ext_blk) do |slice|
              next_uri = slice.links.next_uri
              logger.debug "Next URI: #{next_uri}"
              each(next_uri, &ext_blk) if next_uri
            end

            AsyncInvocation.incorrect
          end

          def get(uri, ext_blk, &recurse_callback)
            AsyncInvocation.incorrect.get if ext_blk.nil?

            request = client.get(uri) do |response|
              logger.debug "GET Response\nURI: #{uri}\nStatus: #{(response.status_code.to_s + " " + response.status_message).rstrip}"

              response.body_handler do |body|
                slice = Slice.build body.to_s
                ext_blk.call(slice)

                recurse_callback.call(slice) if block_given?
              end
            end

            request.put_header('Accept', 'application/vnd.eventstore.atom+json')

            request.exception_handler do |e|
              logger.error e.inspect

              ::Vertx.set_timer(rand(200) + 10) do
                get(uri, ext_blk, &recurse_callback)
              end
            end

            request.end

            AsyncInvocation.incorrect
          end

          def self.slice_path(stream_name, starting_position, slice_size)
            "/streams/#{stream_name}/#{starting_position}/forward/#{slice_size}"
          end

          def self.logger
            Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
