require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    batch = Controls::EventData::Batch.example

    json_text = batch.serialize

    assert(json_text = Controls::EventData::Batch::JSON.text)
  end
end
