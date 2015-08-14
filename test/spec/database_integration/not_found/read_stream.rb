require_relative './not_found_init'

describe "Read Slices from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"
  path = "/streams/#{stream_name}"

  reader = EventStore::Client::HTTP::StreamReader::Terminal.build stream_name, slice_size: 1

  reader.each do |slice|
    specify "Slices are read" do
      assert(slice.nil?)
    end
  end
end
