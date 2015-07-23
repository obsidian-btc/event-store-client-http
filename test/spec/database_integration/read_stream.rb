require_relative './database_integration_init'

describe "Read Slices" do
  stream_name = Fixtures::EventData.write 2, 'testSliceReaderEach'

  reader = EventStore::Client::HTTP::StreamReader.build stream_name, slice_size: 1

  slices = []

  reader.each do |slice|
    slices << slice
  end

  specify "Slices are read" do
    assert(slices.length == 3)
  end

  specify "All but the last slice has entries" do
    2.times do |i|
      number_of_entries = slices[i].data['entries'].length
      assert(number_of_entries == 1)
    end
  end

  specify "The last slice has no entries" do
    number_of_entries = slices.last.data['entries'].length
    assert(number_of_entries == 0)
  end
end
