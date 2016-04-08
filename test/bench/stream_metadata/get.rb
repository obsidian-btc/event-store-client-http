require_relative '../bench_init'

context "Retrieving the metadata associated with a stream" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write 1, 'testGetMetadata'

  get_metadata = EventStore::Client::HTTP::StreamMetadata::Get.build

  metadata = get_metadata.(stream_name)

  test "Metadata for the stream is read" do
    assert metadata == {}
  end
end
