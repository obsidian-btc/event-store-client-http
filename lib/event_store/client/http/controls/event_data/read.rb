module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Read
            def self.data(number=nil, time: nil, stream_name: nil, metadata: nil, type: nil, omit_metadata: nil)
              reference_time = ::Controls::Time.reference

              number ||= 0
              time ||= reference_time
              stream_name ||= StreamName.reference
              type ||= 'SomeEvent'
              metadata ||= Metadata.data

              omit_metadata ||= false

              data = {
                :updated => reference_time,
                :content => {
                  :event_type => type,
                  :event_number => number,
                  :event_stream_id => stream_name,
                  :data => {
                    :some_attribute => 'some value',
                    :some_time => time
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

              if omit_metadata
                data[:content].delete :metadata
              end

              data
            end

            def self.example(number=nil, position: nil, **arguments)
              data = self.data *arguments

              instance = Serialize::Read.instance data, Client::HTTP::EventData::Read
              instance.position = position if position
              instance
            end

            module JSON
              def self.text(number=nil, time: nil, stream_name: nil, metadata: nil, omit_metadata: nil)
                data = Read.data number, time: time, stream_name: stream_name, metadata: stream_name, omit_metadata: omit_metadata
                ::JSON.generate data
              end
            end
          end
        end
      end
    end
  end
end
