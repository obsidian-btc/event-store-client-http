 module EventStore
  module Client
    module HTTP
      class StreamReader
        attr_reader :start_uri
        attr_accessor :next_uri

        dependency :request, EventStore::Client::HTTP::Request::Get
        dependency :logger, Telemetry::Logger

        def initialize(start_uri)
          @start_uri = start_uri
        end

        def self.build(stream_name, starting_position: nil, slice_size: nil)
          starting_position ||= 0
          slice_size ||= 20

          logger.trace "Building slice reader (Stream Name: #{stream_name}, Starting Position: #{starting_position}, Slice Size: #{slice_size})"

          start_uri = slice_path(stream_name, starting_position, slice_size)
          logger.debug "Starting URI: #{start_uri}"

          new(start_uri).tap do |instance|
            EventStore::Client::HTTP::Request::Get.configure instance
            instance.specialize_request

            Telemetry::Logger.configure instance
            logger.debug "Built slice reader (Stream Name: #{stream_name}, Position: #{starting_position}, Slice Size: #{slice_size})"
          end
        end

        virtual :specialize_request

        def each(uri=nil, &action)
          uri ||= start_uri

          self.next_uri = uri

          while continue?
            slice = self.next(next_uri)
            action.call slice
          end

          nil
        end

        def continue?
          !!next_uri
        end

        def next(uri)
          slice = get(uri)

          advance_uri(slice.links.next_uri)
          logger.debug "Next URI: #{next_uri}"

          return slice
        end

        def advance_uri(next_uri)
          self.next_uri = next_uri
        end

        def get(uri)
          logger.trace "Getting (URI: #{uri})"
          body, _ = request.! uri

          logger.data "(#{body.class}) #{body}"

          Slice.parse(body).tap do
            logger.trace "Got (URI: #{uri})"
          end
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
