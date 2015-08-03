module EventStore
  module Client
    module HTTP
      module Controls
        module Writer
          def self.write(count=nil, stream_name=nil)
            count ||= 1

            stream_name = Controls::StreamName.get stream_name
            path = "/streams/#{stream_name}"

            post = EventStore::Client::HTTP::Request::Post.build

            count.times do |i|
              i += 1

              id = ::Controls::ID.get(i)

              event_data = Controls::EventData::Batch.example(id)

              json_text = event_data.serialize

              post_response = post.! json_text, path
            end

            stream_name
          end
        end
      end
    end
  end
end
