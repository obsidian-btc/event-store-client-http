require_relative 'spec_init'

describe "Deserialized Entry" do
  entry_data = Fixtures::Stream::Entry::JSON.data

  entry = EventStore::Client::HTTP::Stream::Entry.deserialize entry_data

  specify "ID" do
    assert(entry.id == '10000000-0000-0000-0000-000000000000')
  end

  specify "Type" do
    assert(entry.type == 'SomeEvent')
  end

  specify "Number" do
    assert(entry.position == 1)
  end

  specify "Position" do
    assert(entry.relative_position == 11)
  end

  specify "Stream Name" do
    assert(entry.stream_name == 'someStream-10000000-0000-0000-0000-000000000001')
  end

  specify "URI" do
    assert(entry.uri == 'http://127.0.0.1:2113/streams/sendFunds-10000000-0000-0000-0000-000000000001/0')
  end

  specify "Created Time" do
    assert(entry.created_time == '2015-06-30T03:59:21.152087Z')
  end

  specify "Data" do
    control_data = {
      "some_attribute" => "some value",
      "some_time" => "2015-06-07T23:37:01Z"
    }

    assert(entry.data == control_data)
  end

  describe "Metadata" do
    metadata = entry.metadata

    specify "Source Stream Name" do
      source_stream_name = metadata['source_stream_name']
      assert(source_stream_name == 'someStream-10000000-0000-0000-0000-000000000001')
    end

    specify "Correlation Stream Name" do
      correlation_stream_name = metadata['correlation_stream_name']
      assert(correlation_stream_name == 'some_correlation_stream')
    end

    specify "Causation Event ID" do
      causation_event_id = metadata['causation_event_id']
      assert(causation_event_id == 'some_causation_event_id')
    end

    specify "Causation Stream Name" do
      causation_stream_name = metadata['causation_stream_name']
      assert(causation_stream_name == 'some_causation_stream')
    end

    specify "Reply Stream Name" do
      reply_stream_name = metadata['reply_stream_name']
      assert(reply_stream_name == 'some_reply_stream')
    end

    specify "Schema Version" do
      version = metadata['schema_version']
      assert(version == -1)
    end
  end
end
