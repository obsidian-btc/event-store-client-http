 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Continuous < StreamReader
          def specialize_request
            request.enable_long_poll
          end

          def advance_uri(next_uri)
            self.next_uri = (next_uri || self.next_uri)
          end
        end
      end
    end
  end
end
