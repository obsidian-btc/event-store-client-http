require_relative '../database_integration_init'

describe "Get a Stream that Doesn't Exist" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get "testNotFound"
  path = "/streams/#{stream_name}"

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, response = get.! path

  specify "Response status is 404 Not Found" do
    assert(response.status_code == 404)
  end

  specify "Body is empty" do
    assert(body_text.empty?)
  end
end
