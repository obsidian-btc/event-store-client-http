 module EventStore
  module Client
    module HTTP
      class StreamReader
        class Terminal < StreamReader
          def self.configure(receiver, stream_name, starting_position: starting_position, slice_size: slice_size)
            instance = build stream_name, starting_position: starting_position, slice_size: slice_size
            receiver.stream_name = instance
            instance
          end

          def each(&action)
            enumerator.each do |slice, next_uri|
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
