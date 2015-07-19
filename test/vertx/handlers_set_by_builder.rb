require_relative './vertx_init'

event_data = EventStore::Client::HTTP::EventData.build
event_data.assign_id

event_data.type = 'SomeEvent'
event_data.data = {
  'some_attribute' => 'some value',
  'some_time' => Clock::UTC.iso8601
}

client = ::Vertx::HttpClient.new
EventStore::Client::HTTP::Settings.instance.set(client, strict: false)

stream_name = "someStream-#{event_data.id}"
path = "/streams/#{stream_name}"

batch = EventStore::Client::HTTP::EventData::Batch.build
batch.add event_data
json_text = batch.serialize

builder = EventStore::Client::HTTP::Vertx::Write::Request::Builder.build client, path, json_text

body_handled = false
builder.body_handler do |body|
  body_handled = true
  TestLogger.debug "Body: #{body.to_s}"
end

exception_handled = false
builder.exception_handler do |e|
  exception_handled = true
  TestLogger.debug "Exception: #{e.inspect}"
end

request = builder.request

request.put_header('Content-Length', json_text.length)
request.write_str(json_text)

Vertx.set_timer(1000) do
  TestLogger.info "Body handled: #{body_handled}"
  TestLogger.info "Excepton handled: #{exception_handled}"
end

# Note: To exercise the exception path, stop the EventStore server
