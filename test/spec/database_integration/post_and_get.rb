require_relative './database_integration_init'

describe "Posting event data" do
  stream_name = Controls::StreamName.get "testPostAndGet"
  path = "/streams/#{stream_name}"

  data = Controls::EventData::Batch::JSON.text

  post = EventStore::Client::HTTP::Request::Post.build
  post_response = post.! data, path

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, get_response = get.! "#{path}/0"

  specify "Post responds with successful status" do
    assert(post_response.is_a? Net::HTTPCreated)
  end

  specify "Get responds with successful status" do
    assert(get_response.is_a? Net::HTTPOK)
  end

  specify "Written data is retrieved" do
    body = JSON.parse(body_text)

    content = body['content']
    data = content['data']
    metadata = content['metadata']

    assert(data == {"someAttribute" => "some value"})
    assert(metadata == {"someMetaAttribute" => "some meta value"})
  end
end
