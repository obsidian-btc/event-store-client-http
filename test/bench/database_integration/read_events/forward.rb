require_relative '../../bench_init'

context "Read Events Forward" do
  control_writer = EventStore::Client::HTTP::Controls::Writer
  stream_name = control_writer.write 2, 'testEventReaderBackward'

  event_reader = EventStore::Client::HTTP::Reader.build stream_name, slice_size: 1, direction: :forward

  events = []
  event_reader.each do |event|
    events << event
  end

  events.each do |event|
    __logger.data event.inspect
  end

  test "Events are read" do
    assert(events.length == 2)
  end

  test "First written is read first" do
    first = events[0].created_time
    last = events[1].created_time

    __logger.data "First Created Time: #{first}"
    __logger.data " Last Created Time: #{last}"

    assert(first < last)
  end
end
