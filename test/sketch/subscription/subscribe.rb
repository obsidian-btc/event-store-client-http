require_relative './subscription_init'

stream_name = ENV['STREAM_NAME']
raise "Stream name must be set using the STREAM_NAME environment variable" if stream_name.nil?

event_reader = EventStore::Client::HTTP::EventReader.build stream_name, slice_size: 1

event_reader.subscribe do |event|
  logger(__FILE__).info event.inspect
end
