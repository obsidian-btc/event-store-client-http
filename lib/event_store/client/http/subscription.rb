module EventStore
  module Client
    module HTTP
      class Subscription < EventReader
        def self.stream_reader
          StreamReader::Continuous
        end
      end
    end
  end
end
