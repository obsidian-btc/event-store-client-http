require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    compare_json_text = Fixtures::EventData.json_text

    json_text = Fixtures::EventData.example.serialize

    assert(json_text == compare_json_text)
  end
end
