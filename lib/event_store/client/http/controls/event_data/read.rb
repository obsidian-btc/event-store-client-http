module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            module EmptyMetadata
              module JSON
                def self.data(number=nil, time: nil, stream_name: nil, metadata: nil)
                  reference_time = ::Controls::Time.reference

                  number ||= 0
                  time ||= reference_time
                  stream_name ||= StreamName.reference
                  metadata ||= EventData::Metadata::JSON.data

                  {
                    'updated' => reference_time,
                    'content' => {
                      'eventType' => 'SomeEvent',
                      'eventNumber' => number,
                      'eventStreamId' => stream_name,
                      'data' => {
                        'someAttribute' => 'some value',
                        'someTime' => time
                      },
                      'metadata' => ''
                    },
                    'links' => [
                      {
                        'uri' => "http://localhost:2113/streams/#{stream_name}/#{number}",
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

            module JSON
              def self.data(number=nil, time: nil, stream_name: nil, metadata: nil)
                reference_time = ::Controls::Time.reference

                number ||= 0
                time ||= reference_time
                stream_name ||= StreamName.reference
                metadata ||= EventData::Metadata::JSON.data

                {
                  'updated' => reference_time,
                  'content' => {
                    'eventType' => 'SomeEvent',
                    'eventNumber' => number,
                    'eventStreamId' => stream_name,
                    'data' => {
                      'someAttribute' => 'some value',
                      'someTime' => time
                    },
                    'metadata' => metadata
                  },
                  'links' => [
                    {
                      'uri' => "http://localhost:2113/streams/#{stream_name}/#{number}",
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
