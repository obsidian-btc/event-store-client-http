require_relative './not_found_init'

describe "Read Slices from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

  reader = EventStore::Client::HTTP::StreamReader::Terminal.build stream_name

  enumerated = false
  reader.each do |slice|
    enumerated = true
  end

  specify "Slices are not enumerated" do
    refute(enumerated)
  end
end
