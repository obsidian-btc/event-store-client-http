require_relative '../bench_init'

context "Updating stream metadata" do
  initial_metadata = { :first_attribute => 'value A', :second_attribute => 'value B' }
  updated_metadata = { :first_attribute => 'value C', :third_attribute => 'value D' }
  stream_name = EventStore::Client::HTTP::Controls::Writer.write :stream_metadata => initial_metadata

  stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name

  event_data, response = stream_metadata.update do |metadata|
    metadata.update updated_metadata
  end

  metadata = event_data.data

  test "Prior existing metadata properties are updated" do
    assert metadata[:first_attribute] == 'value C'
  end

  test "Unrelated metadata properties are unchanged" do
    assert metadata[:second_attribute] == 'value B'
  end

  test "New metadata properties are set" do
    assert metadata[:third_attribute] == 'value D'
  end

  test "Event type is set" do
    assert event_data.type == 'MetadataUpdated'
  end

  test "EventStore accepts the submitted metadata" do
    assert response.status_code == 201
  end
end
