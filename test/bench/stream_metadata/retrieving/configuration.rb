require_relative '../../bench_init'

context "Configuring a Receiver of Read Stream Metadata" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get

  context "Receiver can be configured" do
    receiver = OpenStruct.new

    test "Default attribute name" do
      EventStore::Client::HTTP::StreamMetadata::Read.configure receiver, stream_name

      assert receiver.read_stream_metadata.is_a?(EventStore::Client::HTTP::StreamMetadata::Read)
    end

    test "Custom attribute name" do
      EventStore::Client::HTTP::StreamMetadata::Read.configure receiver, stream_name, attr_name: :some_attr_name

      assert receiver.some_attr_name.is_a?(EventStore::Client::HTTP::StreamMetadata::Read)
    end
  end

  context "Session is passed in" do
    session = EventStore::Client::HTTP::Session.build
    update = EventStore::Client::HTTP::StreamMetadata::Read.build stream_name, session: session

    test "Session is set" do
      assert update.session == session
    end
  end

  context "Session is not passed in" do
    update = EventStore::Client::HTTP::StreamMetadata::Read.build stream_name

    test "Session is set" do
      assert update.session.is_a?(EventStore::Client::HTTP::Session)
    end
  end
end
