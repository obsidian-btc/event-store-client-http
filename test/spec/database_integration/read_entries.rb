require_relative './database_integration_init'

describe "Read Events" do

  stream_name = Fixtures::EventData.write 2, 'testEntryReader'

  slice_reader = EventStore::Client::HTTP::SliceReader.build stream_name

  uri = slice_reader.start_uri

  slice = slice_reader.next(uri)

  raw_entries = slice.entries

  reader = EventStore::Client::HTTP::EntryReader.build

  reader.each_entry(raw_entries) do |entry|
    logger(__FILE__).data entry.inspect
  end
end
