module Goliath::Chimp
  module Rack::Validation
    class RequiredRoutes
      include Goliath::Rack::Validator

      attr_reader :route_key, :select_routes

      def initialize(app, key, routes = {})
        @app = app
        @route_key = key
        @select_routes = routes
      end

      def call env
        if endpoint = env['routes'][route_key] rescue nil
          route, required = select_routes.detect{ |name, required| name === endpoint }          
          return validation_error(400, "A #{required} route is required for #{endpoint}") if required && env['routes'][required].nil?
          @app.call env
        else
          @app.call env
        end
      end
    end
  end
end
