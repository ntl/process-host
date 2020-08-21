class ProcessHost
  module Controls
    module Await
      def self.call(timeout_milliseconds: nil, poll_interval_milliseconds: nil, &condition)
        timeout_milliseconds ||= self.timeout_milliseconds
        poll_interval_milliseconds ||= self.poll_interval_milliseconds

        t0 = Time.now
        t1 = t0

        timeout_seconds = timeout_milliseconds / 1_000.0
        poll_interval_seconds = poll_interval_milliseconds / 1_000.0

        loop do
          condition_met = condition.()

          return true if condition_met

          t2 = Time.now

          elapsed_time = t2 - t0
          if elapsed_time > timeout_seconds
            return false
          end

          cycle_elapsed_time = t2 - t1

          sleep_duration = poll_interval_seconds - cycle_elapsed_time

          t1 = t2

          sleep(sleep_duration) unless sleep_duration < 0
        end
      end

      def self.timeout_milliseconds
        100
      end

      def self.poll_interval_milliseconds
        10
      end
    end
  end
end
