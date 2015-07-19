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

          def self.deserialize(entry_data)
            logger.trace "Deserializing entry (Type: #{entry_data['eventType']}, ID: #{entry_data['id']}, Stream Name: #{entry_data['stream_name']})"

            data = {}

            data['id'] = entry_data['eventId']
            data['type'] = entry_data['eventType']
            data['stream_name'] = entry_data['streamId']
            data['position'] = entry_data['eventNumber']
            data['relative_position'] = entry_data['positionEventNumber']
            data['uri'] = entry_data['id']
            data['created_time'] = entry_data['updated']

            entry_data_data = entry_data['data']
            if entry_data_data && !entry_data_data.empty?
              data['data'] = deserialize_embedded_data(entry_data_data)
            end

            entry_data_metadata = entry_data['metaData']
            if entry_data_metadata && !entry_data_metadata.empty?
              data['metadata'] = deserialize_embedded_data(entry_data_metadata)
              data['metadata']['event_id'] = entry_data['eventId']
              data['metadata']['source_stream_name'] = entry_data['streamId']
            end

            instance = build(data)

            logger.debug "Deserialized entry (Type: #{instance.type}, ID: #{instance.id}, Stream Name: #{instance.stream_name})"

            instance
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
