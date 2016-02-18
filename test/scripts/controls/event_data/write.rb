require_relative '../../scripts_init'

subject = EventStore::Client::HTTP::Controls::EventData::Write::JSON
Controls.output subject, :data
Controls.output subject, :text

subject = EventStore::Client::HTTP::Controls::EventData::Write
Controls.output subject, :example
