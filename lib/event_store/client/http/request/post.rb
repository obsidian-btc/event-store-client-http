module EventStore
  module Client
    module HTTP
      module Request
        class Post
          class ExpectedVersionError < RuntimeError; end

          include Request

          def !(data, path, expected_version: nil)
            logger.trace "Posting to #{path}"
            logger.data data

            response = post(data, path, expected_version)

            logger.info "POST Response\nPath: #{path}\nStatus: #{(response.code + " " + response.message).rstrip}"
            logger.debug "Posted to #{path}"

            response
          end

          def post(data, path, expected_version=nil)
            request = build_request(data, path, expected_version)

            response = client.request(request)

            if "#{response.code} #{response.message}" == "400 Wrong expected EventNumber"
              raise ExpectedVersionError, "Wrong expected version number: #{expected_version} (Path: #{path})"
            end

            response
          end

          def build_request(data, path, expected_version=nil)
            logger.trace "Building request (Path: #{path}, Expected Version: #{!!expected_version ? expected_version : '(none)'}"
            request = Net::HTTP::Post.new(path)

            set_event_store_content_type_header(request)
            set_expected_version_header(request, expected_version) if !!expected_version

            request.body = data

            logger.debug "Built request (Path: #{path}, Expected Version: #{!!expected_version ? expected_version : '(none)'}"

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
