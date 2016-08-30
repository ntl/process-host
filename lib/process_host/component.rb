module ProcessHost
  module Component
    def self.included cls
      cls.class_exec do
        extend Start
      end
    end

    def supervisor
      @supervisor ||= Supervisor.new
    end

    module Start
      def start
        instance = new
        instance.start
        instance
      end
    end
  end
end
