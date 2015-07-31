require_relative './subscription_init'

stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testSubscription"
logger(__FILE__).info "Stream name: #{stream_name}"

stream_name_file = 'tmp/stream_name'
File.write stream_name_file, stream_name

at_exit do
  File.unlink stream_name_file
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

  logger(__FILE__).data result.inspect

  sleep period_seconds
end
