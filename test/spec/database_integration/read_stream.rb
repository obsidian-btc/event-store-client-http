require_relative './database_integration_init'

context "Read Slices" do
  stream_name = EventStore::Client::HTTP::Controls::Writer.write 2, 'testStreamReader'

  reader = EventStore::Client::HTTP::StreamReader::Terminal.build stream_name, slice_size: 1

  slices = []
  reader.each do |slice|
    slices << slice
  end

  test "Slices are read" do
    assert(slices.length == 3)
  end

  test "All but the last slice has entries" do
    2.times do |i|
      number_of_entries = slices[i].data['entries'].length
      assert(number_of_entries == 1)
    end
  end

  test "The last slice has no entries" do
    number_of_entries = slices.last.data['entries'].length
    assert(number_of_entries == 0)
  end
end
