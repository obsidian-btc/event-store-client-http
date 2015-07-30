require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    batch = EventStore::Client::HTTP::Controls::EventData::Batch.example

    json_text = batch.serialize

    assert(json_text = EventStore::Client::HTTP::Controls::EventData::Batch::JSON.text)
  end
end
