require_relative '../bench_init'

context "Updating metadata for stream that does not exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get

  stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name

  event_data, response = stream_metadata.update do |metadata|
    fail "There is no metadata to update since stream does not exist"
  end

  test "No event is generated" do
    assert event_data.nil?
  end

  test "No HTTP call is performed" do
    assert response.nil?
  end
end
