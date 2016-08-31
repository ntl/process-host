module ProcessHost
  module Component
    def self.included cls
      cls.class_exec do
        extend Start
      end
    end

    attr_writer :supervisor

    def supervisor
      @supervisor ||= Actor::Supervisor.new
    end

    module Start
      def start supervisor=nil
        instance = new
        instance.supervisor = supervisor
        instance.start
        instance
      end
    end
  end
end
