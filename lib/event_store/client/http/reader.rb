module EventStore
  module Client
    module HTTP
      class Reader < EventReader
        def self.stream_reader
          StreamReader::Terminal
        end
      end
    end
  end
end
