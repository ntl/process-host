require_relative '../../automated_init'

context "Isolate" do
  context "Process" do
    context "Failed" do
      process = ProcessHost::Isolate::Process.build do
        raise "Some error"
      end

      process.start

      failed = Controls::Await.() do
        process.next == :failed
      end

      test "Process status is failed" do
        assert(process.status == :failed)
      end

      test "Thread is no longer alive" do
        refute(process.thread.alive?)
      end

      context "Raise Thread Error" do
        test "Re-raises the error that crashed the thread" do
          assert_raises(RuntimeError, "Some error") do
            process.raise_thread_error
          end
        end
      end
    end
  end
end
