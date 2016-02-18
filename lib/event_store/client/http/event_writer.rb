 module EventStore
  module Client
    module HTTP
      class EventWriter
        dependency :request, EventStore::Client::HTTP::Request::Post
        dependency :logger, Telemetry::Logger

        def self.build(session: nil)
          logger.opt_trace "Building event writer"

          new.tap do |instance|
            EventStore::Client::HTTP::Request::Post.configure instance, session: session
            Telemetry::Logger.configure instance
            logger.opt_debug "Built event writer"
          end
        end

        def self.configure(receiver, session: nil)
          instance = build(session: session)
          receiver.writer = instance
          instance
        end

        def write(event_data, stream_name, expected_version: nil)
          logger.opt_trace "Writing event data (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
          logger.opt_data "(#{event_data.class}) #{event_data.inspect}"

          batch = batch(event_data)

          write_batch(batch, stream_name, expected_version: expected_version).tap do
            logger.opt_debug "Wrote event data (Stream Name: #{stream_name}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
          end
        end

        def write_batch(batch, stream_name, expected_version: nil)
          logger.trace "Writing batch (Stream Name: #{stream_name}, Number of Events: #{batch.length}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"

          json_text = batch.serialize
          logger.data "(#{json_text.class}) #{json_text}"

          path = path(stream_name)

          request.(json_text, path, expected_version: expected_version).tap do |instance|
            logger.debug "Wrote batch (Stream Name: #{stream_name}, Path: #{path}, Number of Events: #{batch.length}, Expected Version: #{!!expected_version ? expected_version : '(none)'})"
          end
        end

        def batch(event_data)
          logger.opt_trace "Constructing batch"
          EventStore::Client::HTTP::EventData::Batch.build(event_data).tap do
            logger.opt_debug "Constructed batch"
          end
        end

        def path(stream_name)
          "/streams/#{stream_name}"
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end
      end
    end
  end
end
