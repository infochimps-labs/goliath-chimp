module Infochimps
  module Rack
    class ApiVersion
      include Goliath::Rack::AsyncMiddleware
      
      attr_reader :path, :version, :version_header

      def initialize(app, version, options = {})
        @app = app
        @version = version
        @path = options[:path] || '/version'
        @version_header = { "X-#{options[:api] || 'Api'}-Version" => version }
      end

      def call env
        if env['PATH_INFO'] == path
          [200, version_header, version]
        else
          super
        end
      end

      def post_process(env, status, headers, body)
        headers ||= {}
        [status, headers.merge(version_header), body]
      end
    end
  end
end
