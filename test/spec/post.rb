require_relative 'spec_init'

stream_name = Fixtures::Stream.name "testWrite"
path = "/streams/#{stream_name}"

data = Fixtures::EventData::Batch.json_text

client = EventStore::Client::HTTP::ClientBuilder.build_client
post = EventStore::Client::HTTP::Request::Post.build path, client

post.! data
