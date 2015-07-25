 module EventStore
  module Client
    module HTTP
      class EventWriter
        dependency :request, EventStore::Client::HTTP::Request::Post
        dependency :logger, Telemetry::Logger

        def batch
          @batch ||= EventStore::Client::HTTP::EventData::Batch.build
        end

        def self.build
          logger.trace "Building event writer"

          new.tap do |instance|
            EventStore::Client::HTTP::Request::Post.configure instance
            Telemetry::Logger.configure instance
            logger.debug "Built event writer"
          end
        end

        def write(event_data, stream_name, expected_version: nil)
          logger.trace "Writing entry (Stream Name: #{stream_name})"

          json_text = serialize(event_data)
          logger.data "(#{json_text.class}) #{json_text}"

          path = path(stream_name)

          request.!(json_text, path, expected_version: expected_version).tap do |instance|
            logger.debug "Wrote entry (Stream Name: #{stream_name})"
          end
        end

        def path(stream_name)
          "/streams/#{stream_name}"
        end

        def serialize(event_data)
          reset_batch
          batch.add event_data
          batch.serialize
        end

        def reset_batch
          @batch = nil
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
