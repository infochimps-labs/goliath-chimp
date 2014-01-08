module Infochimps
  module Rack
    module Handler
      include Gorillib::Concern
      include Goliath::Rack::Validator

      def valid_response body
        [200, {}, body]
      end

      def crud_methods
        %w[ search create retrieve update delete ]
      end

      def valid_operations
        crud_methods.select{ |m| self.respond_to? m }
      end

      def invalid_operation name
        validation_error(405, "Operation not allowed for #{self.class}. Valid operations are #{valid_operations}")
      end

      def method_missing(name, *args, &blk)
        super unless crud_methods.include? name.to_s
        invalid_operation name
      end

    end
  end
end
