module Infochimps
  module Rack::Validation
    class Routes
      include Goliath::Rack::Validator

      attr_reader :route_regex, :printable_route

      def initialize(app, regex, printable = nil)
        @app = app
        @route_regex = regex
        @printable_route = printable || regex.inspect
      end

      def call env
        if path = env[Goliath::Request::REQUEST_PATH].match(route_regex)
          env['routes'] ||= {}
          path.names.each do |segment|
            env['routes'][segment.to_sym] = path[segment]
          end
          @app.call env
        else
          validation_error(400, "Invalid route. Must match #{printable_route}")
        end
      end
    end
  end
end
