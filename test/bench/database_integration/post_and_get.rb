require_relative '../bench_init'

context "Posting event data" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testPostAndGet"
  path = "/streams/#{stream_name}"

  data = EventStore::Client::HTTP::Controls::EventData::Batch::JSON.text

  post = EventStore::Client::HTTP::Request::Post.build
  post_response = post.(data, path)

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, get_response = get.("#{path}/0")

  test "Post responds with successful status" do
    assert(post_response.status_code == 201)
  end

  test "Get responds with successful status" do
    assert(get_response.status_code == 200)
  end

  test "Written data is retrieved" do
    body = JSON.parse(body_text)

    content = body['content']
    data = content['data']
    metadata = content['metadata']

    assert(data == {"someAttribute" => "some value"})
    assert(metadata == {"someMetaAttribute" => "some meta value"})
  end
end
