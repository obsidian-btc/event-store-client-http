require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    compare_json_text = EventStore::Client::HTTP::Controls::EventData::Write::JSON.text

    json_text = EventStore::Client::HTTP::Controls::EventData::Write.example.serialize

    assert(json_text == compare_json_text)
  end
end
