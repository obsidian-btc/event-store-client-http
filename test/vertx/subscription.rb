require_relative './vertx_init'

stream_name = Fixtures::Stream.name "testSubscription"

event_data = Fixtures::EventData.example


writer = EventStore::Client::HTTP::Vertx::Writer.build
writer.write stream_name, event_data

subscription = EventStore::Client::HTTP::Vertx::Subscription.build stream_name

i = 1
entries = []
subscription.start do |entry|
  entries << entry
  logger(__FILE__).info "#{i} #{entry.inspect}"
  i += 1
end

Vertx.set_timer(5_000) do
  logger(__FILE__).info "Entries Received: #{entries.length}"
end
