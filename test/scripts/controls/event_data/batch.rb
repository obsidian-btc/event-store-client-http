require_relative './event_data_init'

subject = EventStore::Client::HTTP::Controls::EventData::Batch
Controls.output subject, :example

subject = EventStore::Client::HTTP::Controls::EventData::Batch::JSON
Controls.output subject, :text
