 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Terminal < StreamReader
          def each(&action)
            enumerator.each do |slice|
              action.call slice

              next_uri = slice.links.next_uri
              advance_uri(next_uri)

              raise StopIteration if next_uri.nil?
            end
          end
        end
      end
    end
  end
end
