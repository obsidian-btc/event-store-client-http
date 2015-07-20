require_relative './sketch_init'

client = EventStore::Client::HTTP::ClientBuilder.build_client

response = client.get('/')

status = response.status
body = response.body

assert(status == 302, "Response: #{status} #{body}")
