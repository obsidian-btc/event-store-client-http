require_relative '../../scripts_init'

subject = EventStore::Client::HTTP::Controls::EventData::Read::JSON

Controls.output subject, :data
Controls.output subject, :text
