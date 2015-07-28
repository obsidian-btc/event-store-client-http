 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Terminal < StreamReader
          def each(&action)
            enumerator.each do |slice|
              action.call slice
              raise StopIteration if next_uri.nil?
            end
          end
        end
      end
    end
  end
end
