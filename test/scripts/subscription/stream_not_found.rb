require_relative '../scripts_init'

stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"

event_reader = EventStore::Client::HTTP::Subscription.build stream_name

event_reader.each do |event|
  logger(__FILE__).info event.inspect
end
