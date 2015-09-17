require_relative './database_integration_init'

describe "HTTP connection closing" do
  session = EventStore::Client::HTTP::Session.build
  # Close after every request
  session.request_headers["Connection"] = "close"

  stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testEventWriter'
  writer = EventStore::Client::HTTP::EventWriter.build session: session
  event_data = EventStore::Client::HTTP::Controls::EventData::Write.example

  specify "Socket is reset" do
    uuid = SecureRandom.uuid
    3.times do
      writer.write event_data, stream_name
    end
  end
end
