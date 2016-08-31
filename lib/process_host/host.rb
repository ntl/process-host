module ProcessHost
  class Host
    attr_reader :component_names
    attr_reader :supervisor

    def initialize supervisor, component_names
      @component_names = component_names
      @supervisor = supervisor
    end

    def self.build env=nil, supervisor: nil, &block
      env ||= ENV

      supervisor ||= Actor::Supervisor.new

      component_names = Component::NameList.get env

      instance = new supervisor, component_names
      instance.instance_exec supervisor, &block
      instance
    end

    def component component_class
      return unless component_names.include? component_class.name

      component = component_class.start supervisor
      components << component
      component
    end

    def components
      @components ||= Set.new
    end

    module Assertions
      def component? component_class
        components.any? do |component|
          component.instance_of? component_class
        end
      end
    end
  end
end
