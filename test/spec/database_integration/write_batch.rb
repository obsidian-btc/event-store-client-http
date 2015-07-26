require_relative './database_integration_init'

describe "Write Batch of Events" do
  stream_name = Fixtures::Stream.name 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  event_data_1 = Fixtures::EventData::Write.example(Fixtures::ID.get 1)
  event_data_2 = Fixtures::EventData::Write.example(Fixtures::ID.get 2)

  writer.write [event_data_1, event_data_2], stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text_2, get_response = get.! "#{path}/0"
  body_text_1, get_response = get.! "#{path}/1"

  read_data_1 = EventStore::Client::HTTP::EventData::Read.parse body_text_1
  read_data_2 = EventStore::Client::HTTP::EventData::Read.parse body_text_2

  describe "Events are written" do
    2.times do |i|
      event_data = eval("read_data_#{i}")
      logger(__FILE__).data event_data.inspect
    end

    # specify "Stream Name" do
    #   assert(read_data.stream_name == stream_name)
    # end

    # specify "Stream Name" do
    #   assert(read_data.number == 0)
    # end

    # specify "Data" do
    #   assert(read_data.data == {'some_attribute' => 'some value'})
    # end

    # specify "Metadata" do
    #   assert(read_data.metadata == {'some_meta_attribute' => 'some metadata value'})
    # end
  end
end
