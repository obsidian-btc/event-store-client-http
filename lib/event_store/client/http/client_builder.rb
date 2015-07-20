module EventStore
  module Client
    module HTTP
      class ClientBuilder
        def self.configure_client(receiver)
          logger = logger()

          logger.trace "Configuring client (Receiver: #{receiver})"
          client = build_client
          receiver.client = client
          logger.debug "Configured client (Receiver: #{receiver})"

          client
        end

        def self.build_client
          logger.trace "Building HTTP client"

          client = Faraday.new do |client|
            Settings.instance.set(client, strict: false)

            configure_cache(client)
            configure_adapter(client)
          end

          logger.trace "Built HTTP client (Class: #{client.class.name})"

          client
        end

        def self.configure_cache(client)
          logger.trace "Getting default HTTP cache activation setting (Client: #{client.class.name})"
          cache_activation = Defaults::Cache.activation
          if cache_activation == 'on'
            client.use :http_cache, logger: logger
          end
          logger.debug "HTTP cache activation setting: #{cache_activation} (Client: #{client.class.name})"
          cache_activation
        end

        def self.configure_adapter(client)
          logger.trace "Getting default HTTP adapter (Client: #{client.class.name})"
          adapter_name = Defaults::Adapter.name

          client.adapter adapter_name

          logger.debug "Adapter setting: :#{adapter_name} (Client: #{client.class.name})"
          adapter_name
        end

        def self.logger
          @logger ||= Telemetry::Logger.get self
        end

        module Defaults
          module Cache
            def self.activation
              activation = ENV['HTTP_CACHE']
              return activation if activation

              'on'
            end
          end

          module Adapter
            def self.name
              adapter = ENV['HTTP_ADAPTER']
              return adapter.to_sym if adapter

              :net_http
            end
          end
        end
      end
    end
  end
end
