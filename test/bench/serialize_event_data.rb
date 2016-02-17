require_relative 'bench_init'

context "Event Data Serialization" do
  test "Converts to JSON text" do
    compare_json_text = EventStore::Client::HTTP::Controls::EventData::Write::JSON.text

    json_text = EventStore::Client::HTTP::Controls::EventData::Write.example.serialize

    assert(json_text == compare_json_text)
  end
end
