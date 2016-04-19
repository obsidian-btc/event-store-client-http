module EventStore
  module Client
    module HTTP
      class Slice
        class Entry
          include Schema::DataStructure

          attribute :event_uri
          attribute :position
        end
      end
    end
  end
end
