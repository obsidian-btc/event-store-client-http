require_relative './not_found_init'

describe "Read Events from a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

  event_reader = EventStore::Client::HTTP::Reader.build stream_name

  event_reader.each do |event|
    specify "Events are nil" do
      assert(event.nil?)
    end
  end
end
