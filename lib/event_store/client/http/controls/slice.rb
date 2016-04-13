module EventStore
  module Client
    module HTTP
      module Controls
        module Slice
          module JSON
            def self.data(stream_name=nil)
              stream_name ||= 'someStream'

              {
                :links => [
                  {
                    :uri => "http://localhost:2113/streams/#{stream_name}/2/forward/2",
                    :relation => "previous"
                  }
                ],
                :entries => [
                  {
                    :positionEventNumber => 1,
                    :links => [
                      {
                        :uri => "http://localhost:2113/streams/#{stream_name}/1",
                        :relation => "edit"
                      }
                    ]
                  },
                  {
                    :positionEventNumber => 0,
                    :links => [
                      {
                        :uri => "http://localhost:2113/streams/#{stream_name}/0",
                        :relation => "edit"
                      }
                    ]
                  }
                ]
              }
            end

            def self.text
              data.to_json
            end
          end
        end
      end
    end
  end
end
