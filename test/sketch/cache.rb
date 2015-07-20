require_relative './sketch_init'

client = EventStore::Client::HTTP::ClientBuilder.build_client

client.headers = {'Accept' => 'application/vnd.eventstore.atom+json'}

response = client.get '/streams/testSliceReaderEachfdd7d8b0d59046f0bafa40293096c644-69327a66-6789-41ca-843b-9920824492b8/0/forward/20'
response = client.get '/streams/testSliceReaderEachfdd7d8b0d59046f0bafa40293096c644-69327a66-6789-41ca-843b-9920824492b8/0/forward/20'
