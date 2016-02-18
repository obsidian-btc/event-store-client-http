require_relative '../../scripts_init'

subject = EventStore::Client::HTTP::Controls::EventData::Write::Storage
Controls.output subject, :write, 1, 'someStream'
