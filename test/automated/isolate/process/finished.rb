require_relative '../../automated_init'

context "Isolate" do
  context "Process" do
    context "Finished" do
      process = ProcessHost::Isolate::Process.build do
        # Exits immediately
      end

      process.start

      finished = Controls::Await.() do
        process.next == :finished
      end

      test "Process status is finished" do
        assert(process.status == :finished)
      end

      test "Thread is no longer alive" do
        refute(process.thread.alive?)
      end
    end
  end
end
