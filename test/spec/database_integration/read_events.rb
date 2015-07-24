require_relative './database_integration_init'

describe "Read Events" do

  stream_name = Fixtures::EventData.write 2, 'testEntryReader'

  stream_reader = EventStore::Client::HTTP::StreamReader.build stream_name, slice_size: 1

  uri = stream_reader.start_uri

  slice = stream_reader.next(uri)

  raw_entries = slice.entries

  reader = EventStore::Client::HTTP::EventReader.build

  reader.each_entry(raw_entries) do |entry|
    logger(__FILE__).data entry.inspect
  end
end
