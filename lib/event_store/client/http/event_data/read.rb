module EventStore
  module Client
    module HTTP
      class EventData
        class Read < EventData
          attribute :type
          attribute :number
        end
      end
    end
  end
end
