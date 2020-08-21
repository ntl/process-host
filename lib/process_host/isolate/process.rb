# MRuby must start threads from the toplevel namespace
PROCESS_HOST_START_PROCESS_BLOCK = Proc.new { |ready_queue, start_queue, block, *args, **kwargs|
  ready_queue.enq(:ready)
  start_queue.deq

  loop do
    block.(*args, **kwargs)

    break
  end
}

class ProcessHost
  class Isolate
    class Process
      ArgumentError = Class.new(ArgumentError)

      attr_reader :thread
      attr_reader :start_queue
      attr_reader :started
      alias_method :started?, :started

      def initialize(thread, start_queue)
        @thread, @start_queue = thread, start_queue

        @started = false
      end

      def self.build(*args, **kwargs, &block)
        ready_queue = Queue.new
        start_queue = Queue.new

        thread_block = PROCESS_HOST_START_PROCESS_BLOCK

        thread = Thread.new(ready_queue, start_queue, block, *args, **kwargs, &thread_block)

        ready_queue.deq

        ProcessHost::Isolate::Process.new(thread, start_queue)
      end

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

      def start
        start_queue.enq(:start)

        @started = true
      end

      def next
        status
      end

      def status
        return Status.ready unless started?
        return Status.active if thread.alive?
      end

      module Status
        def self.ready
          :ready
        end

        def self.active
          :active
        end
      end
    end
  end
end
