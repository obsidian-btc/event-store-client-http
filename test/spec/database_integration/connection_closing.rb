require_relative './database_integration_init'

describe "HTTP connection closing" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write 101, 'testEventReader'

  event_reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1

  events = []
  event_reader.each do |event|
    events << event
  end

  events.each do |event|
    logger(__FILE__).data event.inspect
  end

  specify "Events are read" do
    assert(events.length == 101)
  end
end

