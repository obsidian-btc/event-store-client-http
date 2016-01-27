require_relative '../database_integration_init'

context "Read Events from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

  reader = EventStore::Client::HTTP::Reader.build stream_name

  enumerated = false
  reader.each do |event|
    enumerated = true
  end

  test "Events are not enumerated" do
    assert !enumerated
  end
end
