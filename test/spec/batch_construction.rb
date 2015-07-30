require_relative 'spec_init'

describe "Construct a Batch from a Single EventData" do
  specify "The single EventData is added to the batch" do
    event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

    batch = EventStore::Client::HTTP::EventData::Batch.build event_data

    assert(batch.length == 1)
    assert(batch.any? event_data)
  end
end

describe "Construct a Batch from a list of EventData" do
  specify "The single EventData is added to the batch" do
    event_data_1 = EventStore::Client::HTTP::Controls::EventData::Write.example
    event_data_2 = EventStore::Client::HTTP::Controls::EventData::Write.example

    batch = EventStore::Client::HTTP::EventData::Batch.build [event_data_1, event_data_2]

    assert(batch.length == 2)
    assert(batch.any? event_data_1)
    assert(batch.any? event_data_2)
  end
end
