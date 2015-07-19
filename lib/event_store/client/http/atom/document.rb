module EventStore
  module Client
    module HTTP
      module ATOM
        class Document
          attr_reader :data

          dependency :logger, Telemetry::Logger

          def initialize(data)
            @data = data
          end

          def self.build(json_text)
            logger.trace 'Building ATOM document'
            data = parse_json(json_text)
            new(data).tap do |instance|
              Telemetry::Logger.configure instance
              logger.debug 'Built ATOM document'
            end
          end

          def self.parse_json(json_text)
            logger.trace "Parsing JSON"
            JSON.parse(json_text).tap do
              logger.debug "Parsed JSON"
            end
          end

          def each_entry(&blk)
            entries = data['entries'].reverse

            logger.trace "Enumerating #{entries.length} entries"

            entries.each do |entry_data|
              entry = Stream::Entry.deserialize entry_data
              blk.call entry
            end

            logger.debug "Enumerated #{entries.length} entries"
          end

          def self.logger
            Telemetry::Logger.get self
          end
        end
      end
    end
  end
end

