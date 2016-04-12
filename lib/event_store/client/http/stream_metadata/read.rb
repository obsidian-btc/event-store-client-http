module EventStore
  module Client
    module HTTP
      module StreamMetadata
        class Read
          attr_accessor :uri

          dependency :logger, Telemetry::Logger
          dependency :session, Session

          def initialize(uri)
            @uri = uri
          end

          def self.build(stream_name, session: nil)
            instance = new stream_name

            session = Session.configure instance, session: session

            URI::Get.configure_uri instance, stream_name, session: session
            Telemetry::Logger.configure instance

            instance
          end

          def self.call(stream_name, session: nil)
            instance = build stream_name, session: session
            instance.()
          end

          def self.configure(receiver, stream_name, attr_name: nil, session: nil)
            attr_name ||= :read_stream_metadata

            instance = build stream_name, session: session
            receiver.public_send "#{attr_name}=", instance
            instance
          end

          def call
            logger.opt_trace "Retrieving stream metadata (URI: #{uri.to_s.inspect})"

            if uri.nil?
              logger.opt_debug "No stream metadata; stream does not exist (URI: #{uri.to_s.inspect})"
              return nil
            end

            response = ::HTTP::Commands::Get.(uri, headers, connection: session.connection)

            logger.opt_debug "Retrieved stream metadata (URI: #{uri.to_s.inspect}, Content Length: #{response['Content-Length']})"

            event_data = EventData::Read.parse response.body
            metadata = event_data.data

            logger.opt_data JSON.pretty_generate(metadata)

            metadata
          end

          def headers
            {
              'Accept' => media_type
            }
          end

          def media_type
            'application/vnd.eventstore.atom+json'
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
end
