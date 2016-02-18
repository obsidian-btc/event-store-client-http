module EventStore
  module Client
    module HTTP
      class EventData
        class Read < EventData
          attribute :number
          attribute :stream_name
          attribute :created_time
          attribute :links

          def self.parse(json_text)
            data = parse_json(json_text)
            build(data)
          end

          def self.parse_json(json_text)
            logger.opt_trace "Parsing JSON"
            logger.opt_data "(#{json_text.class}) #{json_text}"

            data = JSON.parse(json_text)

            logger.opt_debug "Parsed JSON"

            deserialize(data)
          end

          def self.deserialize(event_data)
            logger.opt_trace "Deserializing event data"
            logger.opt_data "(#{event_data.class}) #{event_data}"

            data = {}

            data['created_time'] = event_data['updated']

            content = event_data['content']

            data['type'] = content['eventType']
            data['number'] = content['eventNumber']
            data['stream_name'] = content['eventStreamId']

            data['data'] = format(content['data'])

            unless content['metadata'] == ''
              data['metadata'] = format(content['metadata'])
            end

            links = event_data['links']

            data['links'] = Links.build(links)

            logger.opt_debug "Deserialized entry data (Type: #{data['type']}, ID: #{data['id']}, Stream Name: #{data['stream_name']})"
            logger.opt_data "(#{data.class}) #{data}"

            data
          end

          def self.format(data)
            Casing::Underscore.(data)
          end

          class Links
            attr_reader :edit_uri

            def initialize(edit_uri)
              @edit_uri = edit_uri
            end

            def self.build(links_data)
              logger.opt_trace 'Building event links data'
              logger.opt_data "(#{links_data.class}) #{links_data}"

              links_data ||= []

              edit_uri = get_edit_uri(links_data)

              new(edit_uri).tap do |instance|
                logger.opt_debug 'Built event links data'
              end
            end

            def self.get_edit_uri(links_data)
              links_data.map do |link|
                link['uri'] if link['relation'] == 'edit'
              end.compact.first
            end

            def self.logger
              Telemetry::Logger.get self
            end
          end
        end
      end
    end
  end
end
