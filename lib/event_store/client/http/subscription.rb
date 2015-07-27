module EventStore
  module Client
    module HTTP
      class Subscription
        def initialize(stream_name)
          @stream_name = stream_name
        end

        def self.build(stream_name)
          new(stream_name)
        end

        def start(&action)
          action.call nil
        end
      end
    end
  end
end
