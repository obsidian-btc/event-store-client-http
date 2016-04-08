module EventStore
  module Client
    module HTTP
      class StreamMetadata
        module URI
          class Get
            dependency :logger, Telemetry::Logger
            dependency :session, Session

            def self.build
              instance = new
              Session.configure instance
              Telemetry::Logger.configure instance
              instance
            end

            def self.call(stream_name)
              instance = build
              instance.(stream_name)
            end

            def self.configure(receiver, attr_name: nil)
              attr_name ||= :get_uri

              instance = build
              receiver.public_send "#{attr_name}=", instance
              instance
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
