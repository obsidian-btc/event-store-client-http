require_relative 'bench_init'

context "Stream Slice" do
  json_text = EventStore::Client::HTTP::Controls::Slice::JSON.text
  slice = EventStore::Client::HTTP::Slice.parse(json_text)

  context "Entries" do
    test "Event URI" do
      assert slice.entries[0].uri.match(%r{/streams/someStream/1$})
      assert slice.entries[1].uri.match(%r{/streams/someStream/0$})
    end

    test "Position" do
      assert slice.entries[0].position == 1
      assert slice.entries[1].position == 0
    end
  end

  test "Next URI" do
    assert slice.links.next_uri.match(%r{/streams/someStream/2/forward/2$})
  end
end
