module EventStore
  module Client
    module HTTP
      class Subscription < EventReader
        def configure_dependencies
          logger.trace "Configuring dependencies"
          StreamReader::Continuous.configure self, stream_name, starting_position: starting_position, slice_size: slice_size
          Telemetry::Logger.configure self
          logger.debug "Configured dependencies"
        end
      end
    end
  end
end
