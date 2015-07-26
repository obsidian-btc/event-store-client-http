require_relative 'spec_init'

describe "Construct a Batch from a Single EventData" do
  specify "The single EventData is added to the batch" do
    event_data = Fixtures::EventData::Write.example

    batch = EventStore::Client::HTTP::EventData::Batch.build event_data

    assert(batch.length == 1)
    assert(batch.any? event_data)
  end
end
