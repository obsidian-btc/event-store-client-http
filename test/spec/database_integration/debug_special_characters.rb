require_relative './database_integration_init'

describe "Write Event" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

  event_data.data['some_attribute'] = 'some valué'

  specify "Write event with special characters" do
    writer.write event_data, stream_name
  end
end
