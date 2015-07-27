 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Continuous < StreamReader
          def specialize_request
            request.enable_long_poll
          end

          def continue?
            true
          end

          def advance_uri?(slice)
            !!slice.links.next_uri
          end
        end
      end
    end
  end
end
