require_relative '../bench_init'

context "Retrieve stream metadata" do
  context "Stream exists" do
    control_metadata = { :first_attribute => 'value A', :second_attribute => 'value B' }
    stream_name = EventStore::Client::HTTP::Controls::Writer.write :stream_metadata => control_metadata

    stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name

    metadata = stream_metadata.get

    test "Metadata is retrieved" do
      assert metadata == control_metadata
    end
  end

  context "Stream does not exist" do
    stream_name = EventStore::Client::HTTP::Controls::StreamName.get

    stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name

    metadata = stream_metadata.get

    test "No metadata is returned" do
      assert metadata.nil?
    end
  end
end
