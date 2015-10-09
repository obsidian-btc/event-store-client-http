module EventStore
  module Client
    module HTTP
      module Vertx
        class Write
          attr_reader :stream_name
          attr_reader :event_data
          attr_accessor :expected_version

          dependency :client
          dependency :request, Request
          dependency :logger, Telemetry::Logger

          def batch
            @batch ||= EventStore::Client::HTTP::EventData::Batch.build
          end

          def reset_batch
            @batch = nil
          end

          def initialize(stream_name, event_data)
            @stream_name = stream_name
            @event_data = event_data
          end

          def self.build(stream_name, event_data, expected_version: nil, client: nil)
            logger.trace "Building (#{digest(stream_name, event_data, expected_version)})"
            instance = new(stream_name, event_data).tap do |instance|

              instance.expected_version = expected_version

              instance.configure_logger

              instance.configure_client(client)
              instance.configure_request

              logger.debug "Built (#{digest(stream_name, event_data, expected_version)})"
            end
          end

          def configure_logger
            Telemetry::Logger.configure self
          end

          def configure_client(client=nil)
            if client
              self.client = client
            else
              ClientBuilder.configure_client self
            end
          end

          def configure_request
            Request.configure self, stream_name, client
          end

          def self.call(stream_name, event_data, expected_version: nil, client: nil)
            instance = build(stream_name, event_data, expected_version: expected_version, client: client)
            instance.()
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def call
            logger.trace "Writing (#{digest})"

            json = serialize(event_data)

            request.(json, expected_version: expected_version).tap do
              logger.info "Wrote (#{digest})"
            end
          end
          class << self; alias :! :call; end # TODO: Remove deprecated actuator [Kelsey, Thu Oct 08 2015]

          def serialize(event_data)
            reset_batch
            batch.add event_data
            batch.serialize
          end

          def self.digest(stream_name, event_data, expected_version)
            digest = "Stream Name: #{stream_name}, #{event_data.digest}, Expected Version: "

            if expected_version
              digest << "#{expected_version}"
            else
              digest << "none"
            end

            digest
          end

          def digest
            self.class.digest(stream_name, event_data, expected_version)
          end

          def self.logger
            @logger ||= Telemetry::Logger.get self
          end
        end
      end
    end
  end
end
