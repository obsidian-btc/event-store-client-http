module EventStore
  module Client
    module HTTP
      module StreamMetadata
        module URI
          class Get
            dependency :logger, Telemetry::Logger
            dependency :session, Session

            def self.build(session: nil)
              instance = new

              Session.configure instance, session: session

              Telemetry::Logger.configure instance

              instance
            end

            def self.call(stream_name, session: nil)
              instance = build session: session
              instance.(stream_name)
            end

            def self.configure_uri(receiver, stream_name_or_uri, session: nil, attr_name: nil)
              attr_name ||= :uri

              uri =
                case stream_name_or_uri
                when ::URI then stream_name_or_uri
                else self.(stream_name_or_uri, session: session)
                end

              receiver.public_send "#{attr_name}=", uri

              uri
            end

            def call(stream_name)
              logger.opt_trace "Retrieving stream metadata URI (Stream: #{stream_name.inspect})"

              stream_data = get_stream_data stream_name
              return nil if stream_data.nil?

              uri = get_metadata_uri stream_data

              logger.opt_debug "Retrieved stream metadata URI (Stream: #{stream_name.inspect}, URI: #{uri.inspect})"

              ::URI.parse uri
            end

            def get_stream_data(stream_name)
              uri = session.build_uri "/streams/#{stream_name}"

              logger.opt_trace "Retrieving stream data (URI: #{uri.to_s.inspect})"

              response = ::HTTP::Commands::Get.(uri, headers, connection: session.connection)

              logger.opt_debug "Received stream data response (Status: #{response.status_code}, Content Length: #{response['Content-Length']})"

              return nil if response.status_code == 404

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
