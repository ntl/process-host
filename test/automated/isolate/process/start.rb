require_relative '../../automated_init'

_context "Isolate" do
  context "Process" do
    context "Start" do
      start_queue = Queue.new
      start_queue.enq(1)

      finish_queue = Queue.new

      process = ProcessHost::Isolate::Process.build(start_queue, finish_queue) do |start_queue, finish_queue|
        number = start_queue.deq

        finish_queue.enq(number + 10)

        next
      end

      context "Not Yet Started" do
        test "Thread is spawned" do
          assert(process.thread.alive?)
        end

        test "Process status is ready" do
          assert(process.status == :ready)
        end

        test "Block has not been executed" do
          assert(start_queue.size == 1)
        end
      end

      context "Process Started" do
        process.start

        status_changed = Controls::Await.() do
          process.next != :ready
        end

        test "Process status is changed" do
          assert(status_changed)
        end

        test "Process status is active" do
          assert(process.status == :active)
        end

        test "Block is executed" do
          assert(finish_queue.deq == 11)
        end
      end
    end
  end
end
