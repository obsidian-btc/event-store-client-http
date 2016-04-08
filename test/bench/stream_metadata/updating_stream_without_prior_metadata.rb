require_relative '../bench_init'

context "Updating metadata for stream with no prior metadata" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write
  control_metadata = EventStore::Client::HTTP::Controls::StreamMetadata.data

  stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name

  event_data, response = stream_metadata.update do |metadata|
    metadata.update control_metadata
  end

  test "Metadata is written as the data portion of an event" do
    assert event_data.data == control_metadata
  end

  test "Event type is set" do
    assert event_data.type == 'MetadataUpdated'
  end

  test "EventStore accepts the submitted metadata" do
    assert response.status_code == 201
  end
end
