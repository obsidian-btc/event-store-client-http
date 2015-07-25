module EventStore
  module Client
    module HTTP
      class Slice
        attr_reader :data

        dependency :logger, Telemetry::Logger

        def entries
          data['entries']
        end

        def links
          @links ||= Links.build data['links']
        end

        def initialize(data)
          @data = data
        end

        def self.build(data)
          logger.trace 'Building slice'

          new(data).tap do |instance|
            Telemetry::Logger.configure instance
            logger.debug 'Built slice'
          end
        end

        def self.parse(json_text)
          data = parse_json(json_text)
          logger.data "(#{data.class}) #{data}"

          build(data)
        end

        def self.parse_json(json_text)
          logger.trace "Parsing JSON"

          JSON.parse(json_text).tap do
            logger.debug "Parsed JSON"
          end
        end

        def each(&action)
          entries.reverse_each do |event_json_data|
            action.call event_json_data
          end
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end

      class Links
        attr_reader :next_uri

        def initialize(next_uri)
          @next_uri = next_uri
        end

        def self.build(links)
          logger.trace 'Building page links'

          links ||= []

          next_uri = get_next_uri(links)

          new(next_uri).tap do |instance|
            logger.debug 'Built page links'
            logger.data links
          end
        end

        def self.get_next_uri(links)
          links.map do |link|
            link['uri'] if link['relation'] == 'previous'
          end.compact.first
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end
    end
  end
end
