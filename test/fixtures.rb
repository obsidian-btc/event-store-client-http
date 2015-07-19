require 'pathname'
require 'time'

module Fixtures
  module ATOM
    module Document
      def self.data
        JSON.parse(text)
      end

      def self.text
        File.read(filepath)
      end

      def self.filepath
        pathname = Pathname.new __FILE__
        pathname = Pathname.new pathname.dirname
        pathname += 'data/someStream.json'
        pathname.to_s
      end
    end
  end

  module Stream
    def self.name(category=nil, id=nil)
      category ||= 'test'
      id ||= UUID.random
      category_name = "#{category}#{UUID.random.gsub('-', '')}"
      "#{category_name}-#{id}"
    end

    module Slice
      def self.data
        JSON.parse(text)
      end

      def self.text
        File.read(filepath)
      end

      def self.filepath
        pathname = Pathname.new __FILE__
        pathname = Pathname.new pathname.dirname
        pathname += 'data/slice.json'
        pathname.to_s
      end
    end

    module Entry
      def self.data
        {
          id: '10000000-0000-0000-0000-000000000000',
          type: 'SomeEvent',
          number: 1,
          position: 11,
          stream_name: 'someStream',
          uri: 'http://127.0.0.1:2113/streams/someStream/1',
          created_time: '2015-06-08T04:37:01.066935Z',
          data: {
            'some_attribute' => 'some value',
            'some_time' => '2015-06-07T23:37:01Z'
          },
          metadata: {
            "some_meta_attribute" => "some meta value"
          }
        }
      end

      module JSON
        def self.data
          ::JSON.parse(text)
        end

        def self.text
          File.read(filepath)
        end

        def self.filepath
          pathname = Pathname.new __FILE__
          pathname = Pathname.new pathname.dirname
          pathname += 'data/entry.json'
          pathname.to_s
        end
      end
    end
  end

  module EventData
    def self.example(id=nil)
      id ||= '10000000-0000-0000-0000-000000000000'

      event_data = EventStore::Client::HTTP::EventData.build

      event_data.id = id

      event_data.type = 'SomeEvent'

      event_data.data = {
        'some_attribute' => 'some value'
      }

      event_data.metadata = Metadata.data

      event_data
    end

    def self.json_text(time=nil)
      time ||= Time.now.iso8601(5)
      data_text = '"eventId":"10000000-0000-0000-0000-000000000000","eventType":"SomeEvent","data":{"someAttribute":"some value"}'
      "{#{data_text},#{Metadata.json_text}}"
    end

    def self.write(count=nil, stream_name=nil)
      count ||= 1

      stream_name = Fixtures::Stream.name stream_name
      writer = EventStore::Client::HTTP::Vertx::Writer.build

      i = 0
      timer_id = Vertx.set_periodic(1) do
        i += 1
        if i <= count
          first_octet = (i).to_s.rjust(8, '0')
          id = "#{first_octet}-0000-0000-0000-000000000000"
          event_data = Fixtures::EventData.example id
          writer.write stream_name, event_data
        else
          Vertx.cancel_timer(timer_id)
        end
      end

      stream_name
    end

    module Batch
      def self.json_text
        '[{"id":"10000000-0000-0000-0000-000000000000","type":"SomeEvent","data":{"someAttribute":"some value"}}]'
      end

      def self.example
        batch = EventStore::Client::HTTP::EventData::Batch.build
        batch.add EventData.example
        batch
      end
    end
  end

  module Metadata
    def self.data
      {
        source_stream_name: 'some_source_stream',
        correlation_stream_name: 'some_correlation_stream',
        causation_event_id: 'some_causation_event_id',
        causation_stream_name: 'some_causation_stream',
        reply_stream_name: 'some_reply_stream',
        version: -1
      }
    end

    def self.json_text
      '"metaData":{"sourceStreamName":"some_source_stream","correlationStreamName":"some_correlation_stream","causationEventId":"some_causation_event_id","causationStreamName":"some_causation_stream","replyStreamName":"some_reply_stream","version":-1}'
    end
  end
end
