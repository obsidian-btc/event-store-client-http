module EventStore
  module Client
    module HTTP
      class Slice
        attr_reader :data

        dependency :logger, Telemetry::Logger

        def entries
          @entries ||= data[:entries].map do |entry_data|
            Entry.build entry_data
          end
        end

        def length
          entries.length
        end

        def links
          @links ||= Links.build data[:links]
        end

        def initialize(data)
          @data = data
        end

        def self.build(data)
          logger.opt_trace 'Building slice'

          new(data).tap do |instance|
            Telemetry::Logger.configure instance
            logger.opt_debug 'Built slice'
          end
        end

        def self.parse(json_text)
          data = parse_json(json_text)
          logger.opt_data "(#{data.class}) #{data}"

          build(data)
        end

        def self.parse_json(json_text)
          logger.opt_trace "Parsing JSON"

          JSON.parse(json_text, :symbolize_names => true).tap do
            logger.opt_debug "Parsed JSON"
          end
        end

        def each(direction, &action)
          method_name = (direction == :forward ? :reverse_each : :each)

          entries.send(method_name) do |event_json_data|
            action.call event_json_data
          end
        end

        def next_uri(direction)
          method_name = (direction == :forward ? :next_uri : :previous_uri)

          links.send method_name
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end

      class Entry
        include Schema::DataStructure

        attribute :uri
        attribute :position

        def self.build(entry_data)
          raw_data = parse entry_data

          instance = new
          instance.position = raw_data[:position]
          instance.uri = raw_data[:uri]
          instance
        end

        def self.parse(entry_data)
          raw_data = {}

          entry_data[:links].each do |link|
            raw_data[:uri] = link[:uri] if link[:relation] == 'edit'
          end

          raw_data[:position] = entry_data[:positionEventNumber]

          raw_data
        end
      end

      class Links
        attr_reader :next_uri
        attr_reader :previous_uri

        def initialize(next_uri, previous_uri)
          @next_uri = next_uri
          @previous_uri = previous_uri
        end

        def self.build(links)
          logger.opt_trace 'Building page links'

          links ||= []

          next_uri = get_next_uri(links)
          previous_uri = get_previous_uri(links)

          new(next_uri, previous_uri).tap do |instance|
            logger.opt_debug 'Built page links'
            logger.opt_data links
          end
        end

        def self.get_next_uri(links)
          links.map do |link|
            link[:uri] if link[:relation] == 'previous'
          end.compact.first
        end

        def self.get_previous_uri(links)
          links.map do |link|
            link[:uri] if link[:relation] == 'next'
          end.compact.first
        end

        def self.logger
          Telemetry::Logger.get self
        end
      end
    end
  end
end
