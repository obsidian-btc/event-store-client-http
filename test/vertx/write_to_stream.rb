require_relative './vertx_init'

event_data = EventStore::Client::HTTP::EventData.build

event_data.assign_id
event_data.type = 'SomeEvent'

event_data.data = {
  'some_attribute' => 'some value',
  'some_time' => Clock::UTC.iso8601
}

stream_name = Fixtures::Stream.name "testWrite"

write = EventStore::Client::HTTP::Vertx::Write.build stream_name, event_data
write.configure_logger

write.!
