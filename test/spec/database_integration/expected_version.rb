require_relative './database_integration_init'

context "Writing the Expected Version Number" do
  context "Right Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    test "Succeeds" do
      writer.write event_data_2, stream_name, expected_version: 0
    end
  end

  context "Wrong Version" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testWrongVersion'

    writer = EventStore::Client::HTTP::EventWriter.build

    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    writer.write event_data_1, stream_name

    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    test "Fails" do
      begin
        writer.write event_data_2, stream_name, expected_version: 11
      rescue EventStore::Client::HTTP::Request::Post::ExpectedVersionError => error
      end

      assert error
    end
  end
end
