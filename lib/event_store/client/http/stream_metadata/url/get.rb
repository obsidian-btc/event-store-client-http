module EventStore
  module Client
    module HTTP
      module StreamMetadata
        module URL
          class Get
            dependency :get, ::HTTP::Commands::Get
            dependency :logger, Telemetry::Logger
            dependency :session, Session

            def self.build
              instance = new
              ::HTTP::Commands::Get.configure instance
              Session.configure instance
              Telemetry::Logger.configure instance
              instance
            end

            def self.call(stream_name)
              instance = build
              instance.(stream_name)
            end

            def self.configure(receiver, attr_name: nil)
              attr_name ||= :get_url

              instance = bulid
              receiver.public_send "#{attr_name}=", instance
              instance
            end

            def call(stream_name)
              logger.trace "Retrieving stream metadata URI (Stream: #{stream_name.inspect})"

              stream_data = get_stream_data stream_name

              uri = get_metadata_uri stream_data

              logger.debug "Retrieved stream metadata URI (Stream: #{stream_name.inspect}, URI: #{uri.inspect})"

              uri
            end

            def get_stream_data(stream_name)
              uri = session.build_uri "/streams/#{stream_name}"

              logger.trace "Retrieving stream data (URI: #{uri.to_s.inspect})"

              response = ::HTTP::Commands::Get.(uri, headers, connection: session.connection)

              logger.debug "Received stream data response (Status: #{response.status_code}, Response Size: #{response.body.bytesize})"

              body = response.body
              JSON.parse body
            end

            def get_metadata_uri(stream_data)
              links = stream_data.fetch 'links'

              metadata_link = links.detect do |link|
                link['relation'] == 'metadata'
              end

              metadata_link.to_h.fetch 'uri'
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
end
