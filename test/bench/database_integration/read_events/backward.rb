require_relative '../../bench_init'

context "Read Events Backward" do
  control_writer = EventStore::Client::HTTP::Controls::Writer
  stream_name = control_writer.write 2, 'testEventReaderBackward'

  event_reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :backward

  events = []
  event_reader.each do |event|
    events << event
  end

  events.each do |event|
    __logger.focus event.inspect
  end

  test "Events are read" do
    assert(events.length == 2)
  end

  test "First written is read last" do
    first = events[0].created_time
    last = events[1].created_time

    __logger.focus "First Created Time: #{first}"
    __logger.focus " Last Created Time: #{last}"

    assert(last < first)
  end
end
