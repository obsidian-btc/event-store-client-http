require_relative './vertx_init'

client = EventStore::Client::HTTP::Vertx::ClientBuilder.build_client

client.get_now('/') do |resp|
  status = resp.status_code
  assert(status == 302, "Response: #{status} #{resp.status_message}")
end
