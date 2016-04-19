require_relative '../../bench_init'

context "Configuring a Receiver of Update Stream Metadata" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get

  context "Receiver can be configured" do
    receiver = OpenStruct.new

    test "Default attribute name" do
      EventStore::Client::HTTP::StreamMetadata::Update.configure receiver, stream_name

      assert receiver.update_stream_metadata.is_a?(EventStore::Client::HTTP::StreamMetadata::Update)
    end

    test "Custom attribute name" do
      EventStore::Client::HTTP::StreamMetadata::Update.configure receiver, stream_name, attr_name: :some_attr_name

      assert receiver.some_attr_name.is_a?(EventStore::Client::HTTP::StreamMetadata::Update)
    end
  end

  context "Session is passed in" do
    session = EventStore::Client::HTTP::Session.build
    update = EventStore::Client::HTTP::StreamMetadata::Update.build stream_name, session: session

    test "Event writer's session is set" do
      assert update.event_writer.request.session == session
    end
  end
end
