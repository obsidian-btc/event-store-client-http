require_relative './database_integration_init'

describe "Writing the Expected Version Number" do
  describe "Right Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    specify "Succeeds" do
      writer.write event_data_2, stream_name, expected_version: 0
    end
  end

  describe "Wrong Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    specify "Fails" do
      assert_raises(EventStore::Client::HTTP::Request::Post::ExpectedVersionError) do
        writer.write event_data_2, stream_name, expected_version: 11
      end
    end
  end
end
