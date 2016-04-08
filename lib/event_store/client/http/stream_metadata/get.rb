module EventStore
  module Client
    module HTTP
      module StreamMetadata
        class Get
          dependency :get_url, URL::Get
          dependency :logger, Telemetry::Logger
          dependency :session, Session

          def self.build
            instance = new
            URL::Get.configure instance
            Session.configure instance
            Telemetry::Logger.configure instance
            instance
          end

          def self.call(stream_name)
            instance = build
            instance.(stream_name)
          end

          def self.configure(receiver, attr_name: nil)
            attr_name ||= :get_stream_metadata

            instance = build
            receiver.public_send "#{attr_name}=", instance
            instance
          end

          def call(stream_name)
            logger.trace "Retrieving stream metadata (Stream: #{stream_name.inspect})"

            url = get_url.(stream_name)

            response = ::HTTP::Commands::Get.(url, headers, connection: session.connection)

            logger.debug "Received stream metadata (Stream: #{stream_name.inspect}, Status: #{response.status_code}, Content Length: #{response['Content-Length']})"

            metadata = JSON.parse response.body

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
        end
      end
    end
  end
end
