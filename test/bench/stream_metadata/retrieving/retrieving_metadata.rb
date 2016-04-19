require_relative '../../bench_init'

context "Retrieve stream metadata" do
  context "Stream exists" do
    control_metadata = { :first_attribute => 'value A', :second_attribute => 'value B' }
    stream_name = EventStore::Client::HTTP::Controls::Writer.write stream_metadata: control_metadata

    metadata = EventStore::Client::HTTP::StreamMetadata::Read.(stream_name)

    test "Metadata is retrieved" do
      assert metadata == control_metadata
    end
  end

  context "Stream does not exist" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get

    metadata = EventStore::Client::HTTP::StreamMetadata::Read.(stream_name)

    test "No metadata is returned" do
      assert metadata.nil?
    end
  end
end
