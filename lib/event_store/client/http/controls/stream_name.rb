module EventStore
  module Client
    module HTTP
      module Controls
        module StreamName
          def self.reference
            'someStream'
          end

          def self.get(category=nil, id=nil, random: nil)
            category ||= 'test'
            id ||= Identifier::UUID.random
            random ||= true

            if random
              category_name = "#{category}#{Identifier::UUID.random.gsub('-', '')}"
            end

            "#{category_name}-#{id}"
          end
        end
      end
    end
  end
end
