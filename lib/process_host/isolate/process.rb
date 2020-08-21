class ProcessHost
  class Isolate
    class Process
      ArgumentError = Class.new(ArgumentError)

      def self.assure_transferrable(*arguments)
        arguments.each do |argument|
          assure_transferrable_argument(argument)
        end
      end

      def self.assure_transferrable_argument(argument)
        case argument
        when Array
          assure_transferrable(*argument)

        when Hash
          argument.each do |key, value|
            assure_transferrable(key, value)
          end

        when *transferrable_classes
          true

        else
          raise ArgumentError, "Argument #{argument.inspect} cannot be transferred to process (Transferrable Classes: #{transferrable_classes.join(', ')})"
        end
      end

      def self.transferrable_classes
        [
          Array, Hash,
          TrueClass, FalseClass, NilClass,
          Integer, Float,
          String, Symbol,
          Mutex, Queue
        ]
      end
    end
  end
end
