require_relative './subscription_init'

stream_name = nil
begin
  stream_name = File.read "tmp/stream_name"
rescue
  raise "Stream name file is missing (tmp/stream_name). It's created by the write_events_periodically.rb script, which must be run concurrently with #{__FILE__}."
end

event_reader = EventStore::Client::HTTP::Subscription.build stream_name, slice_size: 1

event_reader.subscribe do |event|
  logger(__FILE__).info event.inspect
end
