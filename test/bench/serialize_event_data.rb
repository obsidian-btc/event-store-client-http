require_relative 'bench_init'

context "Event Data Serialization" do
  test "Converts to raw data" do
    control_json_data = EventStore::Client::HTTP::Controls::EventData::Write.data

    write_event_data = EventStore::Client::HTTP::Controls::EventData::Write.example
    json_data = Serialize::Write.raw_data write_event_data

    assert json_data == control_json_data
  end
end
