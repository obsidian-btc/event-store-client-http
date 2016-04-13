module EventStore
  module Client
    module HTTP
      class Slice
        include Schema::DataStructure

        attribute :entries, Array[Entry]
        attribute :links, Links

        def each(direction, &action)
          if direction == :forward
            method_name = :reverse_each
          else
            method_name = :each
          end

          entries.public_send method_name do |entry|
            action.call entry
          end
        end

        def length
          entries.length
        end

        def next_uri(direction)
          if direction == :forward
            links.next_uri
          else
            links.previous_uri
          end
        end

        module Serializer
          def self.json
            JSON
          end

          def self.instance(raw_data)
            links = self.links raw_data['links']

            entries = self.entries raw_data['entries']

            Slice.build :entries => entries, :links => links
          end

          def self.entries(entry_datum)
            entry_datum.map do |entry_data|
              entry = Entry.new

              entry.position = entry_data['position_event_number']

              entry_data['links'].each do |link_data|
                entry.event_uri = link_data['uri'] if link_data['relation'] == 'edit'
              end

              entry
            end
          end

          def self.links(links_data)
            links = Links.new

            links_data.each do |link_data|
              if link_data['relation'] == 'previous'
                links.next_uri = link_data['uri']
              elsif link_data['relation'] == 'next'
                links.previous_uri = link_data['uri']
              end
            end

            links
          end

          module JSON
            def self.deserialize(text)
              formatted_data = ::JSON.parse text
              Casing::Underscore.(formatted_data)
            end
          end
        end
      end
    end
  end
end
