require_relative './subscription_init'

stream_name = Fixtures::Stream.name "testSubscription"
logger(__FILE__).info "Stream name: #{stream_name}"

writer = EventStore::Client::HTTP::EventWriter.build

period = ENV['PERIOD']
period ||= 200
period_seconds = Rational(period, 1000)

i = 0
loop do
  i += 1

  id = Fixtures::ID.get i
  event_data = Fixtures::EventData::Write.example id
  result = writer.write event_data, stream_name

  logger(__FILE__).data result.inspect

  sleep period_seconds
end
