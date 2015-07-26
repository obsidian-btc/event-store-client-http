require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    batch = Fixtures::EventData::Batch.example
    json_text = batch.serialize

    assert(json_text = Fixtures::EventData::Batch.json_text)
  end
end
