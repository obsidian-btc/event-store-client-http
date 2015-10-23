require_relative 'spec_init'

describe "Deserialized Entry" do
  context "No Metadata" do
    json_text = EventStore::Client::HTTP::Controls::EventData::Read::JSON.text(omit_metadata: true)
    event_data = EventStore::Client::HTTP::EventData::Read.parse json_text

    specify "Metadata" do
      assert(event_data.metadata.nil?)
    end
  end
end
