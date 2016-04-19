module EventStore
  module Client
    module HTTP
      class Slice
        class Links
          include Schema::DataStructure

          attribute :next_uri
          attribute :previous_uri
        end
      end
    end
  end
end
