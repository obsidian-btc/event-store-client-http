module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            module JSON
              def self.data(number=nil, time: nil, stream_name: nil, metadata: nil, omit_metadata: nil)
                reference_time = ::Controls::Time.reference

                number ||= 0
                time ||= reference_time
                stream_name ||= StreamName.reference

                omit_metadata ||= false

                unless omit_metadata
                  metadata ||= EventData::Metadata::JSON.data
                else
                  metadata = ''
                end

                {
                  :updated => reference_time,
                  :content => {
                    :eventType => 'SomeEvent',
                    :eventNumber => number,
                    :eventStreamId => stream_name,
                    :data => {
                      :someAttribute => 'some value',
                      :someTime => time
                    },
                    :metadata => metadata
                  },
                  :links => [
                    {
                      :uri => "http://localhost:2113/streams/#{stream_name}/#{number}",
                      :relation => 'edit'
                    }
                  ]
                }
              end

              def self.text(number=nil, time: nil, stream_name: nil, metadata: nil, omit_metadata: nil)
                data(number, time: time, stream_name: stream_name, metadata: stream_name, omit_metadata: omit_metadata).to_json
              end
            end
          end
        end
      end
    end
  end
end
