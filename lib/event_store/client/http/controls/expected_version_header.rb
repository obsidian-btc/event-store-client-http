module EventStore
  module Client
    module HTTP
      module Controls
        module ExpectedVersionHeader
          module FieldName
            def self.example
              'ES-ExpectedVersion'
            end
          end

          module NoStream
            def self.example
              -1
            end
          end
        end
      end
    end
  end
end
