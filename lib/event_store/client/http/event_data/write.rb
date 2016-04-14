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

          module Serializer
            def self.raw_data(instance)
              {
                :event_id => instance.id,
                :event_type => instance.type,
                :data => instance.data,
                :metadata => instance.metadata
              }
            end
          end
        end
      end
    end
  end
end
