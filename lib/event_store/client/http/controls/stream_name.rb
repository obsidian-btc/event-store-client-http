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
            random ||= true

            if random
              category_name = "#{category}#{Identifier::UUID.random.gsub('-', '')}"
              id ||= Identifier::UUID.random
              return "#{category_name}-#{id}"
            else
              return category
            end
          end
        end
      end
    end
  end
end
