require_relative 'spec_init'

describe "Event Data" do
  specify "Assign ID" do
    event_data = EventStore::Client::HTTP::EventData.build
    event_data.assign_id
    refute(event_data.id.nil?)
  end

  specify "ID can't be re-assigned" do
    event_data = EventStore::Client::HTTP::EventData.build
    event_data.assign_id

    assert_raises(EventStore::Client::HTTP::EventData::IdentityError) do
      event_data.assign_id
    end
  end
end
