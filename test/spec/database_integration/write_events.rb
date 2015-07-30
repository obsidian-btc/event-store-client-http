require_relative './database_integration_init'

describe "Write Event" do
  stream_name = EventStore::Client::HTTP::Controls::StreamName.get 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  event_data = Controls::EventData::Write.example

  writer.write event_data, stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text, get_response = get.! "#{path}/0"

  read_data = EventStore::Client::HTTP::EventData::Read.parse body_text

  logger(__FILE__).data read_data.inspect

  describe "Event is written" do
    specify "Stream Name" do
      assert(read_data.stream_name == stream_name)
    end

    specify "Stream Name" do
      assert(read_data.number == 0)
    end

    specify "Data" do
      assert(read_data.data == {'some_attribute' => 'some value'})
    end

    specify "Metadata" do
      assert(read_data.metadata == {'some_meta_attribute' => 'some meta value'})
    end
  end
end
