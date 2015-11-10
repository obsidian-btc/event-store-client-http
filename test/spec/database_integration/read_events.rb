require_relative './database_integration_init'

describe "Read Events" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write 2, 'testEventReader'

  event_reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1

  events = []
  event_reader.each do |event|
    events << event
  end

  events.each do |event|
    __logger.data event.inspect
  end

  specify "Events are read" do
    assert(events.length == 2)
  end
end
