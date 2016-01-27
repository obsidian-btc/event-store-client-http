require_relative '../database_integration_init'

context "Read Slices from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

  reader = EventStore::Client::HTTP::StreamReader::Terminal.build stream_name

  enumerated = false
  reader.each do |slice|
    enumerated = true
  end

  test "Slices are not enumerated" do
    assert !enumerated
  end
end
