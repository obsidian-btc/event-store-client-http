module EventStore
  module Client
    module HTTP
      class EventData
        class Write < EventData
          attribute :id

          def assign_id
            raise IdentityError, "ID is already assigned (ID: #{id})" unless id.nil?
            self.id = uuid.get
          end

          def serialize
            json_formatted_data.to_json
          end

          def json_formatted_data
            json_data = {
              'eventId' => id,
              'eventType' => type
            }

            json_data['data'] = Casing::Camel.(data, symbol_to_string: true) if data
            json_data['metadata'] = Casing::Camel.(metadata, symbol_to_string: true) if metadata

            json_data
          end
        end
      end
    end
  end
end
