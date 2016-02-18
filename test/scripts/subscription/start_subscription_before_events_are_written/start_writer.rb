ENV['LOG_LEVEL'] ||= 'debug'

require_relative '../../scripts_init'

stream_name = nil
begin
  stream_name = File.read "tmp/stream_name"
rescue
  raise "Stream name file is missing (tmp/stream_name). It's created by the \"start_subscription.rb\" script, which must be run concurrently with #{__FILE__}."
end

writer = EventStore::Client::HTTP::EventWriter.build

period = ENV['PERIOD']
period ||= 200
period_seconds = Rational(period, 1000)

i = 0
loop do
  i += 1

  id = ::Controls::ID.get i
  event_data = EventStore::Client::HTTP::Controls::EventData::Write.example id
  result = writer.write event_data, stream_name

  __logger.data result.inspect

  sleep period_seconds
end
