require_relative 'bench_init'

context "Deserialized Entry" do
  json_text = EventStore::Client::HTTP::Controls::EventData::Read::JSON.text
  event_data = EventStore::Client::HTTP::EventData::Read.parse json_text

  reference_time = Controls::Time.reference

  test "Type" do
    assert(event_data.type == 'SomeEvent')
  end

  test "Number" do
    assert(event_data.number == 0)
  end

  test "Stream Name" do
    assert(event_data.stream_name == 'someStream')
  end

  test "Created Time" do
    assert(event_data.created_time == reference_time)
  end

  test "Data" do
    control_data = {
      'some_attribute' => 'some value',
      'some_time' => reference_time
    }

    assert(event_data.data == control_data)
  end

  test "Metadata" do
    assert(event_data.metadata == { 'some_meta_attribute' => 'some meta value' })
  end

  context "Links" do
    test "Edit" do
      edit_uri = event_data.links.edit_uri
      assert(edit_uri == 'http://localhost:2113/streams/someStream/0')
    end
  end
end
