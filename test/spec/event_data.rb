require_relative 'spec_init'

describe "Event Data" do
  specify "Assign ID" do
    event_data = EventStore::Client::HTTP::EventData::Write.build
    event_data.assign_id
    refute(event_data.id.nil?)
  end

  specify "ID can't be re-assigned" do
    event_data = EventStore::Client::HTTP::EventData::Write.build
    event_data.assign_id

    begin
      event_data.assign_id
    rescue EventStore::Client::HTTP::EventData::IdentityError => error
    end

    assert error
  end
end
