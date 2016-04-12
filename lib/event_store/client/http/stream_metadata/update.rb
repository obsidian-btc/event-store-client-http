module EventStore
  module Client
    module HTTP
      module StreamMetadata
        class Update
          attr_accessor :uri

          dependency :logger, Telemetry::Logger
          dependency :read_metadata, Read
          dependency :event_writer, EventWriter

          def self.build(stream_name, session: nil)
            instance = new

            session ||= Session.build

            read = Read.configure instance, stream_name, session: session, attr_name: :read_metadata
            instance.uri = read.uri

            Telemetry::Logger.configure instance
            EventWriter.configure instance, session: session, attr_name: :event_writer

            instance
          end

          def self.call(stream_name, session: nil, &apply_changes)
            instance = build stream_name, session: session
            instance.(&apply_changes)
          end

          def self.configure(receiver, stream_name, attr_name: nil, session: nil)
            attr_name ||= :update_stream_metadata

            instance = build stream_name, :session => session
            receiver.public_send "#{attr_name}=", instance
            instance
          end

          def call(&apply_changes)
            logger.opt_trace "Updating metadata (URI: #{uri.inspect})"

            metadata = read_metadata.()
            return if metadata.nil?

            apply_changes.(metadata)

            event_data, response = write metadata

            logger.opt_trace "Updated metadata (URI: #{uri.inspect})"

            return event_data, response
          end

          def write(metadata)
            logger.opt_trace "Writing stream metadata (URI: #{uri.to_s.inspect})"
            logger.opt_data JSON.pretty_generate(metadata)

            event_data = HTTP::EventData::Write.build(
              :type => 'MetadataUpdated',
              :data => metadata
            )
            event_data.assign_id

            response = event_writer.write event_data, uri

            logger.opt_debug "Wrote stream metadata (URI: #{uri.to_s.inspect}, Status Code: #{response.status_code}, Event ID: #{event_data.id.inspect})"

            return event_data, response
          end

          def headers
            {
              'Accept' => media_type
            }
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end
        end
      end
    end
  end
end
