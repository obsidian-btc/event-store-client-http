require_relative './database_integration_init'

describe "Write Batch of Events" do
  stream_name = Fixtures::Stream.name 'testEventWriter'
  path = "/streams/#{stream_name}"

  writer = EventStore::Client::HTTP::EventWriter.build

  id_1 = Fixtures::ID.get 1
  id_2 = Fixtures::ID.get 2

  event_data_1 = Fixtures::EventData::Write.example(id_1)
  event_data_2 = Fixtures::EventData::Write.example(id_2)

  event_data_1.data['some_attribute'] = id_1
  event_data_2.data['some_attribute'] = id_2

  writer.write [event_data_1, event_data_2], stream_name

  get = EventStore::Client::HTTP::Request::Get.build
  body_text_1, get_response = get.! "#{path}/0"
  body_text_2, get_response = get.! "#{path}/1"

  read_data_1 = EventStore::Client::HTTP::EventData::Read.parse body_text_1
  read_data_2 = EventStore::Client::HTTP::EventData::Read.parse body_text_2

  2.times do |i|
    i += 1
    event_data = eval("read_data_#{i}")

    specify "Individual events are written" do
      assert(event_data.data['some_attribute'] == eval("id_#{i}"))
    end
  end
end