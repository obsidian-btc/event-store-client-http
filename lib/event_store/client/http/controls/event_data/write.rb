module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Write
            module JSON
              def self.data(id=nil)
                id ||= ::Controls::ID.get sample: false

                {
                  'eventId' => id,
                  'eventType' => 'SomeType',
                  'data' => {'someAttribute' => 'some value'},
                  'metadata' => EventData::Metadata::JSON.data
                }
              end

              def self.text
                data.to_json
              end
            end

            def self.example(id=nil, i: nil, type: nil)
              id ||= ::Controls::ID.get i, sample: false
              type ||= 'SomeType'

              event_data = EventStore::Client::HTTP::EventData::Write.build

              event_data.id = id

              event_data.type = type

              event_data.data = {
                'some_attribute' => 'some value'
              }

              event_data.metadata = EventData::Metadata.data

              event_data
            end
          end
        end
      end
    end
  end
end
