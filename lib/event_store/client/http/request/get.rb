module EventStore
  module Client
    module HTTP
      module Request
        class Get
          include Request

          def !(path)
            logger.trace "Getting from #{path}"

            response = get(path)
            body = response.body

            logger.info "GET Response\nPath: #{path}\nStatus: #{(response.code + " " + response.message).rstrip}"
            logger.debug "Got from #{path}"

            logger.data body

            return body, response
          end

          def get(path)
            request = build_request(path)
            client.request(request)
          end

          def build_request(path)
            request = Net::HTTP::Get.new(path)

            set_event_store_accept_header(request)

            request
          end

          def media_type
            'application/vnd.eventstore.atom+json'
          end

          def set_event_store_accept_header(request)
            request['Accept'] = media_type
          end
        end
      end
    end
  end
end
