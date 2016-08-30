require_relative '../test_init'

context "Actors are initialized by a component" do
  component_cls = Class.new do
    include ProcessHost::Component

    def start
      @address_1, thread_1 = Controls::Actor::Example.spawn include: %i(thread)
      @address_2, thread_2 = Controls::Actor::Example.spawn include: %i(thread)

      supervisor.add @address_1, thread_1
      supervisor.add @address_2, thread_2
    end

    def addresses
      [@address_1, @address_2]
    end
  end

  component = component_cls.start

  test "Actors are added to supervisor" do
    assert component.supervisor do
      component.addresses.all? do |address|
        actor? address
      end
    end
  end
end
