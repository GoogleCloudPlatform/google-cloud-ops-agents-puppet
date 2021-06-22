module Fluent
  module Plugin
    class MyAwesomeInput < Input
      # For `@type my_awesome` in configuration file
      Fluent::Plugin.register_input('my_awesome', self)

      def configure(conf)
        super
      end

      def start
        super
        # ...
      end
    end
  end
end