require_relative '../bench_init'

context "Retrieving the URL for the metadata associated with a stream" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write 1, 'testGetMetadataURL'

  get_url = EventStore::Client::HTTP::StreamMetadata::URL::Get.build
  session = get_url.session

  url = get_url.(stream_name)

  test "Stream metadata URL is read from the links corresponding to the stream" do
    control_url = "http://#{session.host}:#{session.port}/streams/#{stream_name}/metadata"

    assert url == control_url
  end
end
