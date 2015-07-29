require_relative 'spec_init'

describe "Event Data Serialization" do
  specify "Converts to JSON text" do
    compare_json_text = Controls::EventData::Write::JSON.text

    json_text = Controls::EventData::Write.example.serialize

    logger(__FILE__).data compare_json_text
    logger(__FILE__).data json_text

    assert(json_text == compare_json_text)
  end
end
