module ProcessHost
  module Environment
    module ComponentNameList
      def self.get env
        component_names = env['PROCESS_HOST_COMPONENTS']

        if component_names.nil?
          Any
        else
          component_names.split ','
        end
      end

      module Any
        def self.include? component_name
          true
        end
      end
    end
  end
end
