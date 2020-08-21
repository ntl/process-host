require_relative '../../automated_init'

context "Isolate" do
  context "Process" do
    context "ArgumentTransferral" do
      req = Controls::Argument.random
      opt = Controls::Argument.random
      keyreq = Controls::Argument.random
      key = Controls::Argument.random

      queue = Queue.new

      process = ProcessHost::Isolate::Process.build(queue, req, opt, keyreq: keyreq, key: key) do |q, *args, **kwargs|
        args.each do |arg|
          q << arg
        end

        kwargs.each do |_, arg|
          q << arg
        end

        raise StopIteration
      end

      process.start

      context "Required Positional Argument" do
        transferred = queue.shift == req

        test "Transferred" do
          assert(transferred)
        end
      end

      context "Optional Positional Argument" do
        transferred = queue.shift == opt

        test "Transferred" do
          assert(transferred)
        end
      end

      context "Required Keyword Argument" do
        transferred = queue.shift == keyreq

        test "Transferred" do
          assert(transferred)
        end
      end

      context "Optional Keyword Argument" do
        transferred = queue.shift == key

        test "Transferred" do
          assert(transferred)
        end
      end
    end
  end
end
