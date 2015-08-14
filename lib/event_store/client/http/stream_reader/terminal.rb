 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Terminal < StreamReader
          def each(&action)
            enumerator.each do |slice, next_uri|
              raise StopIteration if slice.nil?

              action.call slice

              raise StopIteration if next_uri.nil?

              advance_uri(next_uri)
            end
          end
        end
      end
    end
  end
end
