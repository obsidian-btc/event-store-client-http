module EventStore
  module Client
    module HTTP
      module Request
        class Post
          class ExpectedVersionError < RuntimeError; end

          include Request

          def call(data, uri, expected_version: nil)
            logger.trace "Issuing POST (Path: #{uri}, Expected Version: #{expected_version.inspect})"
            logger.data data

            uri = session.build_uri(uri)

            headers = self.headers(expected_version)
            response = ::HTTP::Commands::Post.(data, uri, headers)

            if "#{response.status_code} #{response.reason_phrase}" == '400 Wrong expected EventNumber'
              raise ExpectedVersionError, "Wrong expected version number: #{expected_version} (URI: #{uri})"
            end

            logger.debug "Issued POST (Path: #{uri}, Status Line: #{response.status_line.inspect})"

            response
          end
          alias :! :call # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def headers(expected_version=nil)
            headers = {}
            set_event_store_content_type_header(headers)
            unless expected_version.nil?
              expected_version = -1 if expected_version == self.class.no_stream_version
              set_expected_version_header(headers, expected_version)
            end
            headers
          end

          def self.no_stream_version
            :no_stream
          end

          def media_type
            'application/vnd.eventstore.events+json'
          end

          def set_event_store_content_type_header(request)
            request['Content-Type'] = media_type
          end

          def set_expected_version_header(request, expected_version)
            request['ES-ExpectedVersion'] = expected_version
          end
        end
      end
    end
  end
end
