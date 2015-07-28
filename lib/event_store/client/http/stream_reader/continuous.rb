 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Continuous < StreamReader
          def each(&action)
            request.enable_long_poll
            enumerator.each do |slice, next_uri|
              action.call slice

              advance_uri(next_uri) if next_uri
            end
          end
        end
      end
    end
  end
end
