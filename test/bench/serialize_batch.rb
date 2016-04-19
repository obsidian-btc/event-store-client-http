require_relative 'bench_init'

context "Event Data Serialization" do
  test "Converts to JSON text" do
    batch = EventStore::Client::HTTP::Controls::EventData::Batch.example

    json_text = Serialize::Write.(batch, :json)

    assert(json_text = EventStore::Client::HTTP::Controls::EventData::Batch::JSON.text)
  end
end
