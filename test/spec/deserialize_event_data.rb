require_relative 'spec_init'

describe "Deserialized Entry" do
  json_text = EventStore::Client::HTTP::Controls::EventData::Read::JSON.text
  event_data = EventStore::Client::HTTP::EventData::Read.parse json_text

  reference_time = Controls::Time.reference

  specify "Type" do
    assert(event_data.type == 'SomeEvent')
  end

  specify "Number" do
    assert(event_data.number == 0)
  end

  specify "Stream Name" do
    assert(event_data.stream_name == 'someStream')
  end

  specify "Created Time" do
    assert(event_data.created_time == reference_time)
  end

  specify "Data" do
    control_data = {
      'some_attribute' => 'some value',
      'some_time' => reference_time
    }

    assert(event_data.data == control_data)
  end

  specify "Metadata" do
    assert(event_data.metadata == { 'some_meta_attribute' => 'some meta value' })
  end

  specify "Empty metadata" do
    json_text = EventStore::Client::HTTP::Controls::EventData::Read::EmptyMetadata::JSON.text

    event_data = EventStore::Client::HTTP::EventData::Read.parse json_text
    assert_equal({}, event_data.metadata)
  end

  describe "Links" do
    specify "Edit" do
      edit_uri = event_data.links.edit_uri
      assert(edit_uri == 'http://localhost:2113/streams/someStream/0')
    end
  end
end
