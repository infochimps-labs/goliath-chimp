module Goliath::Chimp
  module Rack
    class ControlMethods

      attr_reader :method_map

      def initialize(app, map = {})
        @app = app ; @method_map = map
      end

      def call env
        request_method = (env['HTTP_X_METHOD'] || env['REQUEST_METHOD']).to_s.upcase
        if control_method = method_map[request_method]
          env['control_method'] = control_method
        end
        @app.call env
      end
    end
  end
end
