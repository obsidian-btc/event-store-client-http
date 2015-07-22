 module EventStore
  module Client
    module HTTP
      class SliceReader
        attr_accessor :stream_name
        attr_writer :starting_position
        attr_reader :start_uri
        attr_accessor :next_uri

        dependency :request, EventStore::Client::HTTP::Request::Get
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

          logger.trace "Building Reader (Stream Name: #{stream_name}, Starting Position: #{starting_position}, Slice Size: #{slice_size})"

          start_uri = slice_path(stream_name, starting_position, slice_size)
          logger.debug "Starting URI: #{start_uri}"

          new(start_uri).tap do |instance|
            EventStore::Client::HTTP::Request::Get.configure instance
            Telemetry::Logger.configure instance
            logger.debug "Built Reader (Stream Name: #{stream_name}, Position: #{starting_position}, Slice Size: #{slice_size})"
          end
        end

        def each(uri=nil, &action)
          uri ||= start_uri

          self.next_uri = uri

          while next?
            slice = self.next(next_uri)
            action.call slice
          end

          nil
        end

        def next?
          !!next_uri
        end

        def next(uri)
          slice = get(uri)

          self.next_uri = slice.links.next_uri
          logger.debug "Next URI: #{next_uri}"

          return slice
        end

        def get(uri)
          logger.trace "Getting (URI: #{uri})"
          body, _ = request.! uri

          logger.data body

          Stream::Slice.build(body).tap do
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
