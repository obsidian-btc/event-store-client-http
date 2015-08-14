require_relative './not_found_init'

describe "Read Events from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

  reader = EventStore::Client::HTTP::Reader.build stream_name

  enumerated = false
  reader.each do |event|
    enumerated = true
  end

  specify "Events are not enumerated" do
    refute(enumerated)
  end
end
