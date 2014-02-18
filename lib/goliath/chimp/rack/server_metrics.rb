module Goliath::Chimp
  module Rack
    class ServerMetrics
      include Goliath::Rack::AsyncMiddleware
      include EnvExtractor

      attr_reader :path, :env_key, :default

      def initialize(app, options = {})
        @app     = app
        @path    = options[:path]    || '/metrics'
        @env_key = options[:env_key]
        @default = options[:default] || '/*'
      end

      def call env
        if env['PATH_INFO'] == path
          [ 200, {}, env['status'] ]
        else
          super
        end
      end

      def post_process(env, status, headers, body)
        base_metrics = { count: 0, total_millis: 0 }
        env['status'][:requests] ||= Hash.new{ |h, k| h[k] = Hash.new{ |h, k| h[k] = base_metrics } }
        request_key    = extract_from_env(env, env_key, default)
        request_method = env['REQUEST_METHOD'].downcase.to_sym
        metrics = env['status'][:requests][request_key][request_method]
        metrics[:count] += 1
        elapsed_millis = ((Time.now.to_f - env[:start_time]) * 1000).round
        metrics[:total_millis] += elapsed_millis
        [status, headers, body]        
      end

    end
  end
end
