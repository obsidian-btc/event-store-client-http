module EventStore
  module Client
    module HTTP
      module Request
        class Post
          include Request

          def !(data, path, expected_version: nil)
            logger.debug "Posting to #{path}"
            logger.data data

            response = post(data, path)

            logger.debug "POST Response\nPath: #{path}\nStatus: #{(response.code + " " + response.message).rstrip}"
            logger.trace "Posted to #{path}"

            response
          end

          def post(data, path)
            request = build_request(data, path)
            client.request(request)
          end

          def build_request(data, path, expected_version=nil)
            request = Net::HTTP::Post.new(path)

            set_event_store_content_type_header(request)
            set_expected_version_header(request, expected_version) if expected_version

            request.body = data

            request
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
