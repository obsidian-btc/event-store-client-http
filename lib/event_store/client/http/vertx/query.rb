          def select
            raise NotImplementedError
          end

          def detect
            # built on select, but exits after returning one
            raise NotImplementedError
          end

          def any?
            # built on detect
            raise NotImplementedError
          end

          # May not make sense. Maybe better to just have each?
          # No. This is necessary. It returns items.
          def map
            # built on each
            raise NotImplementedError
          end
