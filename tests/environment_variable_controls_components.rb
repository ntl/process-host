require_relative '../test_init'

context "Components are selected by specifying environment variable" do
  env = {
    'PROCESS_HOST_COMPONENTS' =>
      'ProcessHost::Controls::Component::Example::A,ProcessHost::Controls::Component::Example::B'
  }

  host = ProcessHost::Host.build env do
    component Controls::Component::Example::A
    component Controls::Component::Example::B
    component Controls::Component::Example::C
  end

  test "Only components specified by environment variable are started" do
    assert host do
      component? Controls::Component::Example::A
    end

    assert host do
      component? Controls::Component::Example::B
    end

    refute host do
      component? Controls::Component::Example::C
    end
  end
end
