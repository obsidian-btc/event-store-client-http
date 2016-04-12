require_relative '../bench_init'

context "Retrieving the URL for the metadata associated with a stream" do
  get_url = EventStore::Client::HTTP::StreamMetadata::URI::Get.build

  context "Stream exists" do
    stream_name = EventStore::Client::HTTP::Controls::Writer.write 1, 'testGetMetadataURL'

    url = get_url.(stream_name)

    test "Stream metadata URL is read from the links corresponding to the stream" do
      session = get_url.session
      control_url = URI.parse "http://#{session.host}:#{session.port}/streams/#{stream_name}/metadata"

      assert url == control_url
    end
  end

  context "Stream does not exist" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get

    url = get_url.(stream_name)

    test "No URL is returned" do
      assert url.nil?
    end
  end
end
