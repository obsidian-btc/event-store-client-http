require_relative './database_integration_init'

describe "Posting event data" do
  stream_name = Fixtures::Stream.name "testWrite"
  path = "/streams/#{stream_name}"

  data = Fixtures::EventData::Batch.json_text

  client = EventStore::Client::HTTP::ClientBuilder.build_client

  post = EventStore::Client::HTTP::Request::Post.build client
  post_response = post.! data, path

  get = EventStore::Client::HTTP::Request::Get.build client
  get_response = get.! "#{path}/0"

  specify "Responds with successful status" do
    assert(post_response.is_a? Net::HTTPCreated)
  end
end
