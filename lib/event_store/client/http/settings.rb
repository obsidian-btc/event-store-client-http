module EventStore
  module Client
    module HTTP
      class Settings < ::Settings
        def self.instance
          @instance ||= build
        end

        def self.data_source
          'settings/event_store_client_http.json'
        end
      end
    end
  end
end
