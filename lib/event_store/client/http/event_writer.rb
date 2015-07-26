 module EventStore
  module Client
    module HTTP
      class EventWriter
        dependency :request, EventStore::Client::HTTP::Request::Post
        dependency :logger, Telemetry::Logger

        def self.build
          logger.trace "Building event writer"

          new.tap do |instance|
            EventStore::Client::HTTP::Request::Post.configure instance
            Telemetry::Logger.configure instance
            logger.debug "Built event writer"
          end
        end

        # def write(event_data, stream_name, expected_version: nil)
        #   logger.trace "Writing entry (Stream Name: #{stream_name})"

        #   json_text = serialize(event_data)
        #   logger.data "(#{json_text.class}) #{json_text}"

        #   path = path(stream_name)

        #   request.!(json_text, path, expected_version: expected_version).tap do |instance|
        #     logger.debug "Wrote entry (Stream Name: #{stream_name})"
        #   end
        # end

        def write(event_data, stream_name, expected_version: nil)
          logger.trace "Writing entry (Stream Name: #{stream_name})"

          json_text = serialize(event_data)
          logger.data "(#{json_text.class}) #{json_text}"

          path = path(stream_name)

          request.!(json_text, path, expected_version: expected_version).tap do |instance|
            logger.debug "Wrote entry (Stream Name: #{stream_name})"
          end
        end

        def write(event_data, stream_name, expected_version: nil)
          if event_data.is_a? Array
            write_many event_data, stream_name
          else
            write_one event_data, stream_name
          end
        end

        def write_many(event_data, stream_name, expected_version: nil)
          # create batch from array of events
          # write batch
        end

        def write_one(event_data, stream_name, expected_version: nil)
          # create batch from single event
          # write batch
        end


        def write_event
          # create batch with event
          # write batch
        end

        def write_batch
          # serialize batch
          # write batch
        end


        # - - -

        # serialization should only serialize a batch
        # don't serialize a single event
        # has to be an array
        def serialize(event_data)
          reset_batch
          batch.add event_data
          batch.serialize
        end

        def reset_batch
          @batch = nil
        end

        # - - -


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
