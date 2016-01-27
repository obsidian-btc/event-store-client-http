module EventStore
  module Client
    module HTTP
      module Controls
        module Writer
          def self.write(iterations=nil, stream_name=nil)
            iterations ||= 1

            stream_name = Controls::StreamName.get stream_name
            path = "/streams/#{stream_name}"

            post = EventStore::Client::HTTP::Request::Post.build

            iterations.times do |iteration|
              iteration += 1

              id = ::Controls::ID.get(iteration)

              event_data = Controls::EventData::Batch.example(id)

              json_text = event_data.serialize

              post_response = post.(json_text, path)
            end

            stream_name
          end
        end
      end
    end
  end
end
