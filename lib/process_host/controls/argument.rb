class ProcessHost
  module Controls
    module Argument
      def self.example
        Transferrable.example
      end

      module Transferrable
        def self.example
          string
        end

        def self.nil
          nil
        end

        def self.true
          true
        end

        def self.false
          false
        end

        def self.integer
          11
        end

        def self.float
          1.11
        end

        def self.symbol
          :some_symbol
        end

        def self.string
          'some-string'
        end

        def self.array
          [symbol, string]
        end

        def self.hash
          {
            symbol => string
          }
        end

        def self.mutex
          Mutex.new
        end

        def self.queue
          Queue.new
        end
      end

      module NonTransferrable
        def self.example
          Example.new.tap do |example|
            example.some_attribute = Argument.example
          end
        end

        class Example
          attr_accessor :some_attribute
        end
      end
    end
  end
end
