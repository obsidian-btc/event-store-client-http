require_relative './event_data_init'

subject = EventStore::Client::HTTP::Controls::Slice::JSON

Controls.output subject, :data
Controls.output subject, :text
