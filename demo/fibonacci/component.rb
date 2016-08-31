module Demo
  module Fibonacci
    class Component
      include ProcessHost::Component

      def start
        actor, thread = Actor.start 1, include: %i(thread)

        supervisor.add actor, thread
      end
    end
  end
end
