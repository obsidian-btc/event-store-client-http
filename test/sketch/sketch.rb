require_relative './sketch_init'

client = EventStore::Client::HTTP::ClientBuilder.build_client
