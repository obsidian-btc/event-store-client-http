require_relative 'bench_init'

context "Deserialized Entry" do
  context "No Metadata" do
    json_text = EventStore::Client::HTTP::Controls::EventData::Read::JSON.text(omit_metadata: true)
    event_data = Serialize::Read.(json_text, EventStore::Client::HTTP::EventData::Read, :json)

    test "Metadata" do
      assert(event_data.metadata.nil?)
    end
  end
end
