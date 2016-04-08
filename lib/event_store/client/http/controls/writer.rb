module EventStore
  module Client
    module HTTP
      module Controls
        module Writer
          def self.write(iterations=nil, stream_name=nil, initial_metadata: nil, verbatim_stream_name: nil)
            iterations ||= 1
            verbatim_stream_name ||= false

            unless verbatim_stream_name
              stream_name = Controls::StreamName.get stream_name
            end

            path = "/streams/#{stream_name}"

            post = EventStore::Client::HTTP::Request::Post.build

            iterations.times do |iteration|
              iteration += 1

              id = ::Controls::ID.get(iteration)

              event_data = Controls::EventData::Batch.example(id)

              json_text = event_data.serialize

              post_response = post.(json_text, path)
            end

            if initial_metadata
              stream_metadata = EventStore::Client::HTTP::StreamMetadata.build stream_name
              stream_metadata.update do |metadata|
                metadata.update initial_metadata
              end
            end

            stream_name
          end
        end
      end
    end
  end
end
