require_relative 'spec_init'

describe "Entry Equality" do
  entry_data = Fixtures::Stream::Entry.data
  entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
  other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data

  specify "When fields are equal" do
    assert(entry == other_entry)
  end
end

describe "Entry Inequality" do
  entry_data = Fixtures::Stream::Entry.data
  entry = EventStore::Client::HTTP::Stream::Entry.build entry_data

  specify "IDs are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.id = 'something else'
    refute(entry == other_entry)
  end

  specify "Types are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.type = 'SomethingElse'
    refute(entry == other_entry)
  end

  specify "Stream names are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.stream_name = 'someOtherStresm'
    refute(entry == other_entry)
  end

  specify "Entry positions are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.position = 2
    refute(entry == other_entry)
  end

  specify "Entry numbers are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.relative_position = 22
    refute(entry == other_entry)
  end

  specify "Created times are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.created_time = 'some other time'
    refute(entry == other_entry)
  end

  specify "Data are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.data = { some_attribute: 'some other value' }
    refute(entry == other_entry)
  end

  specify "Metadata are not equal" do
    other_entry = EventStore::Client::HTTP::Stream::Entry.build entry_data
    other_entry.metadata = { some_meta_attribute: 'some other meta value' }
    refute(entry == other_entry)
  end
end
