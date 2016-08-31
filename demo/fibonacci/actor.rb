module Demo
  module Fibonacci
    class Actor
      include ::Actor

      def initialize period
        @period = period
        @sequence = []
        @position = 0
      end

      def action
        if @position <= 1
          @sequence << 1

          puts "fib(#{@position}) is 1"
          return
        end

        n0, n1 = @sequence.shift, @sequence[0]

        n2 = n0 + n1

        puts "fib(#{@position}) is #{n2}"

        @sequence << n2

      ensure
        @position += 1
        sleep @period
      end
    end
  end
end
