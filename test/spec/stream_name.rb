require_relative 'spec_init'

module Fixtures
  StreamName = EventStore::Client::HTTP::Stream::Name
end

describe "Stream Name" do
  stream_name = Fixtures::StreamName.stream_name 'someCategory', 'some_id'

  specify "Composes the stream name from the category name and an ID" do
    assert(stream_name == 'someCategory-some_id')
  end
end

describe "Random Category Name" do
  stream_name = Fixtures::StreamName.random_category_name('someCategory')

  specify "Adds a randomized suffix to the category name" do
    assert(stream_name.length > 'someCategory'.length)
    assert(stream_name.start_with? 'someCategory')
  end
end

describe "Random Stream Name" do
  stream_name = Fixtures::StreamName.stream_name 'someCategory', 'some_id', random: true

  specify "Composes the stream name from the randomized category name and an ID" do
    assert(stream_name.length > 'someCategory-some_id'.length)
    assert(stream_name.start_with? 'someCategory')
    assert(stream_name.end_with? 'some_id')
  end
end

describe "Category Stream Name" do
  specify "Composes the category stream name from the category name and the reserve category stream prefix" do
    category_stream_name = Fixtures::StreamName.category_stream_name 'someCategory'
    assert(category_stream_name == '$ce-someCategory')
  end
end

describe "Stream ID" do
  specify "Is the UUID portion of a full stream name" do
    id = UUID.random
    stream_name = "someStream-#{id}"

    stream_id = Fixtures::StreamName.get_id stream_name
    assert(stream_id == id)
  end

  specify "Is nil if there is no type 4 UUID in the stream name" do
    stream_id = Fixtures::StreamName.get_id 'someStream'
    assert(stream_id.nil?)
  end
end
