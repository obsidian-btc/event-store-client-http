require_relative 'spec_init'

describe "Stream Slice" do
  json_text = Controls::Slice::JSON.text
  slice = EventStore::Client::HTTP::Slice.parse(json_text)

  specify "Entries" do
    assert(slice.data['entries'].length == 2)
  end

  specify "Next URI" do
    assert(slice.links.next_uri.match(/someStream\/2\/forward\/2$/))
  end
end
