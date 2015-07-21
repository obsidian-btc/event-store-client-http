require_relative 'spec_init'

describe "Posting event data" do
  stream_name = Fixtures::Stream.name "testWrite"
  path = "/streams/#{stream_name}"

  data = Fixtures::EventData::Batch.json_text

  client = EventStore::Client::HTTP::ClientBuilder.build_client
  post = EventStore::Client::HTTP::Request::Post.build path, client

  specify "Responds with successful status" do
    response = post.! data
    assert(response.is_a? Net::HTTPCreated)
  end
end
