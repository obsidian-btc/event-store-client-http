module EventStore
  module Client
    module HTTP
      module Vertx
        class Subscription
          attr_accessor :stream_name
          attr_accessor :action
          attr_writer :position

          dependency :client
          dependency :logger, Telemetry::Logger

          def position
            @position ||= 0
          end

          def self.build(stream_name, position=nil)
            position ||= 0

            logger.trace "Building subscription (Stream Name: #{stream_name}, Position: #{position})"

            new.tap do |instance|
              # TODO Why are these set rather than constructed [Scott, Thu Jul 9 2015]
              instance.stream_name = stream_name
              instance.position = position

              ClientBuilder.configure_client instance
              Telemetry::Logger.configure instance

              logger.debug "Built subscription (Stream Name: #{stream_name}, Position: #{position})"
            end
          end

          def start(&blk)
            self.action = blk
            stream_data
          end

          def stream_data
            get next_page_path
          end

          def get(path)
            path = embedded_body(path)

            logger.trace "Getting (Path: #{path})"

            request = client.get(path) do |resp|
              logger.debug "Response (Status: #{(resp.status_code.to_s + " " + resp.status_message).rstrip}, Path: #{path})"
              resp.body_handler do |body|
                receive_page body.to_s
              end
            end

            request.put_header('Accept', 'application/vnd.eventstore.atom+json')
            request.put_header('ES-LongPoll', 15)

            request.exception_handler do |e|
              logger.error e.message
            end

            request.end
          end

          def receive_page(atom_text)
            logger.trace "Receiving page"

            doc = EventStore::Client::HTTP::ATOM::Document.build(atom_text)

            doc.each_entry do |entry|
              receive entry
            end

            logger.debug "Received page"
          end

          def receive(entry)
            logger.trace "Receiving entry"
            action.call entry
            logger.debug "Received entry"
          end

          def page_size
            @page_size ||= 20
          end

          def reset_position
            self.position = 0
          end

          def path
            "/streams/#{stream_name}"
          end

          def next_page_path
            "#{path}/#{position}/forward/#{page_size}"
          end

          def embedded_body(path)
            "#{path}?embed=pretty"
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
