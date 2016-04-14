module EventStore
  module Client
    module HTTP
      module Controls
        module EventData
          module Metadata
            def self.raw_data
              {
                some_meta_attribute: 'some meta value'
              }
            end

            module JSON
              def self.data
                {
                  'someMetaAttribute' => 'some meta value'
                }
              end
            end
          end
        end
      end
    end
  end
end
