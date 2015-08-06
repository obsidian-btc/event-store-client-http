module EventStore
  module Client
    module HTTP
      class Reader < EventReader
        def configure_dependencies
          StreamReader::Terminal.configure self, stream_name, starting_position: starting_position, slice_size: slice_size
          Telemetry::Logger.configure self
        end
      end
    end
  end
end
