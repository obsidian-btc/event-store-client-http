require_relative './bench_init'

context "Changing Connection Scheduler" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get
  event_reader = EventStore::Client::HTTP::Subscription.build stream_name
  scheduler = EventStore::Client::HTTP::Controls::ConnectionScheduler.example

  event_reader.change_connection_scheduler scheduler

  test "The scheduler for the event reader's connection is set" do
    assert event_reader.request do
      connection_scheduler? scheduler
    end
  end

  test "The scheduler for the stream reader's connection is set" do
    assert event_reader.stream_reader.request do
      connection_scheduler? scheduler
    end
  end
end
