ENV['LOG_LEVEL'] ||= 'debug'

require_relative '../../scripts_init'

stream_name = nil
begin
  stream_name = File.read "tmp/stream_name"
rescue
  raise "Stream name file is missing (tmp/stream_name). It's created by the \"start_writer.rb\" script, which must be run concurrently with #{__FILE__}."
end

event_reader = EventStore::Client::HTTP::Subscription.build stream_name, slice_size: 1

event_reader.each do |event|
  __logger.info event.inspect
end
