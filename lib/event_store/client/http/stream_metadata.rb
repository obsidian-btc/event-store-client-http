module EventStore
  module Client
    module HTTP
      class StreamMetadata
        attr_reader :stream_name

        dependency :get_uri, URI::Get
        dependency :logger, Telemetry::Logger
        dependency :session, Session
        dependency :writer, EventWriter

        def initialize(stream_name)
          @stream_name = stream_name
        end

        def self.build(stream_name, session: nil)
          instance = new stream_name
          URI::Get.configure instance

          if session.nil?
            session = Session.configure instance
          else
            instance.session = session
          end

          Telemetry::Logger.configure instance
          EventWriter.configure instance, :session => session

          instance
        end

        def self.configure(receiver, stream_name, attr_name: nil)
          attr_name ||= :update_stream_metadata

          instance = build stream_name
          receiver.public_send "#{attr_name}=", instance
          instance
        end

        def get
          logger.trace "Retrieving stream metadata (URI: #{uri.to_s.inspect})"

          return nil if uri.nil?

          response = ::HTTP::Commands::Get.(uri, headers, connection: session.connection)

          logger.debug "Retrieved stream metadata (URI: #{uri.to_s.inspect}, Content Length: #{response['Content-Length']})"

          event_data = EventData::Read.parse response.body
          metadata = event_data.data

          logger.data JSON.pretty_generate(metadata)

          metadata
        end

        def update(&apply_changes)
          logger.trace "Updating metadata (Stream Name: #{stream_name.inspect})"

          metadata = get
          return if metadata.nil?

          apply_changes.(metadata)

          event_data, response = write metadata

          logger.trace "Updated metadata (Stream Name: #{stream_name.inspect})"

          return event_data, response
        end

        def write(metadata)
          logger.trace "Writing stream metadata (URI: #{uri.to_s.inspect})"
          logger.data JSON.pretty_generate(metadata)

          event_data = HTTP::EventData::Write.build(
            :type => 'MetadataUpdated',
            :data => metadata
          )
          event_data.assign_id

          response = writer.write event_data, uri

          logger.debug "Wrote stream metadata (URI: #{uri.to_s.inspect}, Status Code: #{response.status_code}, Event ID: #{event_data.id.inspect})"

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

        def uri
          @uri ||= get_uri.(stream_name)
        end

        module EventData
          class Read < EventStore::Client::HTTP::EventData::Read
            def self.parse(json_text)
              event_data = JSON.parse(json_text, :symbolize_names => true)

              return build(:data => {}) if event_data.empty?

              data = deserialize event_data
              build data
            end
          end
        end
      end
    end
  end
end
