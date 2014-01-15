module Goliath::Chimp
  module Rack
    module Formatters
      class JSON
        #
        # This class is identical to the formatter class
        # Goliath::Rack::Formatters::JSON except that it
        # allows for pretty printing of a response body;
        # something that comes in handy when constructing
        # interactive HTTP APIs.
        #
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
