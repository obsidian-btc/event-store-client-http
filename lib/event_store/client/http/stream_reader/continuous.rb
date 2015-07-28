 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Continuous < StreamReader
          def each(&action)
            request.enable_long_poll
            enumerator.each &action
          end
        end
      end
    end
  end
end
