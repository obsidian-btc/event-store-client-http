module EventStore
  module Client
    module HTTP
      class Reader < EventReader
        def configure_dependencies
          logger.trace "Configuring dependencies"
          StreamReader::Terminal.configure self, stream_name, starting_position: starting_position, slice_size: slice_size
          Telemetry::Logger.configure self
          logger.debug "Configured dependencies"
        end

        def read(&action)
          logger.trace "Reading events (Stream Name: #{stream_name})"

          each_slice(stream_reader, &action)

          logger.debug "Read events (Stream Name: #{stream_name})"
          nil
        end
      end
    end
  end
end
