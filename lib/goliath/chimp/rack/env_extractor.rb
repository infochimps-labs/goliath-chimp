module Goliath::Chimp
  module Rack
    module EnvExtractor
      
      # Helper method for extracting potentially nested
      # values from the env hash. Also normalizes
      # string vs. symbol access.
      #
      def extract_from_env(env, key, default = nil)
        return default unless env.is_a? Hash
        case key
        when String, Symbol
          env[key.to_s] || env[key.to_sym] || default
        when Array
          slice = env[key.shift]
          key.empty? ? slice : extract_from_env(slice, key)
        when Hash
          extract_from_env(env, key.to_a.flatten)
        else
          default
        end
      end

    end
  end
end
