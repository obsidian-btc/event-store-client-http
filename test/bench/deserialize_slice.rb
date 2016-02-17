require_relative 'bench_init'

context "Stream Slice" do
  json_text = EventStore::Client::HTTP::Controls::Slice::JSON.text
  slice = EventStore::Client::HTTP::Slice.parse(json_text)

  test "Entries" do
    assert(slice.data['entries'].length == 2)
  end

  test "Next URI" do
    assert(slice.links.next_uri.match(/someStream\/2\/forward\/2$/))
  end
end
