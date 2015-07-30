module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            module JSON
              def self.data(number=nil, time=nil)
                number ||= 0

                reference_time = ::Controls::Time.reference
                time ||= reference_time

                {
                  'updated' => reference_time,
                  'content' => {
                    'eventType' => 'SomeEvent',
                    'eventNumber' => number,
                    'eventStreamId' => 'someStream',
                    'data' => {
                      'someAttribute' => 'some value',
                      'someTime' => time
                    },
                    'metadata' => EventData::Metadata::JSON.data
                  },
                  'links' => [
                    {
                      'uri' => "http://localhost:2113/streams/someStream/#{number}",
                      'relation' => 'edit'
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
end
