module Goliath::Chimp
  module Rack
    class ForceContentType

      attr_reader :content_type

      def initialize(app, content_type)
        @app = app ; @content_type = content_type
      end

      def call env
        env['CONTENT_TYPE'] = env['HTTP_ACCEPT'] = content_type
        @app.call env
      end
    end
  end
end
