module Infochimps
  module Rack
    module Formatters
      class JSON
        include Goliath::Rack::AsyncMiddleware

        def post_process(env, status, headers, body)
          pretty = !!env['params']['pretty'] rescue false
          if json_response? headers
            body = MultiJson.dump(body, pretty: pretty)
          end
          [status, headers, body]
        end

        def json_response? headers
          headers['Content-Type'] =~ /^application\/(json|javascript)/
        end
      end
    end
  end
end
