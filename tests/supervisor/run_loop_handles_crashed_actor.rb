require_relative '../test_init'

context "Supervisor run loop handles an actor that has crashed" do
  actor_cls = Class.new do
    include Actor

    def action
      sleep 0.1
      fail "Induced error"
    end
  end

  address, thread = actor_cls.start include: %i(thread)

  error = nil

  supervisor = Supervisor.new
  supervisor.add address, thread
  supervisor.exception_notifier = proc { |_error| error = _error }

  test "Error is re-raised by supervisor" do
    assert proc { supervisor.start } do
      raises_error? RuntimeError
    end
  end

  test "Exception notifier is actuated" do
    assert error.instance_of? RuntimeError
  end
end
