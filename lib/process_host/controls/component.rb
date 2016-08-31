module ProcessHost
  module Controls
    module Component
      class Example
        include ProcessHost::Component

        def start
          address, thread = Actor::Example.start include: %i(thread)

          supervisor.add address, thread
        end

        A = Class.new Example
        B = Class.new Example
        C = Class.new Example
      end
    end
  end
end
