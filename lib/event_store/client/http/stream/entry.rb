module EventStore
  module Client
    module HTTP
      module Stream
        class Entry
          attr_accessor :id
          attr_accessor :type
          attr_accessor :stream_name
          attr_accessor :position
          attr_accessor :relative_position
          attr_accessor :uri
          attr_accessor :created_time
          attr_accessor :data
          attr_accessor :metadata

          def self.build(data)
            logger.trace "Building entry"
            new.tap do |instance|
              SetAttributes.! instance, data
              logger.debug "Built entry"
            end
          end

          def self.parse(json_text)
            data = parse_json(json_text)

            build(data)
          end

          def self.parse_json(json_text)
            logger.trace "Parsing JSON"
            logger.data "(#{json_text.class}) #{json_text}"

            data = JSON.parse(json_text)

            logger.debug "Parsed JSON"

            deserialize(data)
          end

          def self.deserialize(entry_data)
            logger.trace "Deserializing entry data (Type: #{entry_data['eventType']}, ID: #{entry_data['eventId']}, Stream Name: #{entry_data['streamId']})"
            logger.data "(#{entry_data.class}) #{entry_data}"

            data = {}

            data['created_time'] = entry_data['updated']

            content = entry_data['content']

            data['type'] = content['eventType']
            data['stream_name'] = content['eventStreamId']
            data['number'] = content['eventNumber']
            data['data'] = content['data']
            data['metadata'] = content['metadata']

            logger.debug "Deserialized entry data (Type: #{data['type']}, ID: #{data['id']}, Stream Name: #{data['stream_name']})"
            logger.data "(#{data.class}) #{data}"

            data
          end

          def self.deserialize_embedded_data(data_text)
            logger.trace "Deserializing embedded data"

            deserialize_data_text(data_text).tap do
              logger.debug "Deserialized embedded data"
            end
          end

          def self.deserialize_data_text(data_text)
            data = JSON.parse(data_text)
            format(data)
          end

          def self.format(data)
            Casing::Underscore.! data
          end

          def ==(other)
            (
              id == other.id &&
              type == other.type &&
              stream_name == other.stream_name &&
              position == other.position &&
              relative_position == other.relative_position &&
              created_time == other.created_time &&
              data == other.data &&
              metadata == other.metadata
            )
          end
          alias :eql :==

          def self.logger
            Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
