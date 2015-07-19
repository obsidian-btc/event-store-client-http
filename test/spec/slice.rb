require_relative 'spec_init'

describe "Stream Slice" do
  json_text = Fixtures::Stream::Slice.text
  slice = EventStore::Client::HTTP::Stream::Slice.build(json_text)

  specify "Entries" do
    assert(slice.data['entries'].length == 3)
  end

  specify "Next URI" do
    assert(slice.links.next_uri.match(/someStream\/3\/forward\/20$/))
  end
end
