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

            Telemetry::Logger.configure instance
            logger.debug "Built slice reader (Stream Name: #{stream_name}, Position: #{starting_position}, Slice Size: #{slice_size})"
          end
        end

        def self.configure(receiver, stream_name, starting_position: nil, slice_size: nil)
          instance = build stream_name, starting_position: starting_position, slice_size: slice_size
          receiver.stream_reader = instance
          instance
        end

        virtual :each

        def advance_uri(next_uri)
          self.next_uri = (next_uri || self.next_uri)
        end

        def to_enum
          Enumerator.new do |y|
            self.next_uri = start_uri
            logger.trace "Enumerating"
            loop do
              slice = self.next(next_uri)
              next_uri = get_next_uri(slice)
              y << [slice, next_uri]
            end
            logger.debug "Enumerated"
          end
        end
        alias :enum_for :to_enum
        alias :enumerator :to_enum

        def next(uri)
          get(uri)
        end

        def get_next_uri(slice)
          next_uri = nil
          unless slice.nil?
            next_uri = slice.links.next_uri
          end
          next_uri
        end

        def advance_uri(uri)
          self.next_uri = uri
          logger.debug "Next URI: #{next_uri}"
        end

        def get(uri)
          logger.trace "Getting (URI: #{uri})"
          body, _ = request.! uri

          logger.data "(#{body.class}) #{body}"

          parse(body).tap do
            logger.trace "Got (URI: #{uri})"
          end
        end

        def parse(body)
          slice = nil
          unless body.empty?
            slice = Slice.parse(body)
          end
          slice
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
