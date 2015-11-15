require_relative 'spec_init'

describe "Expected Version" do
  context "When set" do
    specify "Sets the ES-ExpectedVersion header" do
      post = EventStore::Client::HTTP::Request::Post.new

      path = 'some_path'
      expected_version = 1

      request = post.build_request('some_path', expected_version)

      assert(request.headers.to_s.include? "ES-ExpectedVersion: #{expected_version}")
    end
  end

  context "When set to :no_stream" do
    specify "Sets the ES-ExpectedVersion header to -1" do
      post = EventStore::Client::HTTP::Request::Post.new

      path = 'some_path'
      expected_version = EventStore::Client::HTTP::Request::Post.no_stream_version

      request = post.build_request('some_path', expected_version)

      assert(request.headers.to_s.include? "ES-ExpectedVersion: -1")
    end
  end
end
