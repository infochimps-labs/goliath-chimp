module Goliath::Chimp
  module Handler
    include Gorillib::Concern
    include Goliath::Rack::Validator

    def crud_methods
      %w[ search create retrieve update delete ]
    end

    def valid_operations
      crud_methods.select{ |m| self.respond_to? m }
    end

    def invalid_operation name
      message = "Operation #{name} not allowed for #{self.class}. Valid operations are #{valid_operations}"
      Goliath::Validation::MethodNotAllowedError.new message
    end

    def method_missing(name, *args, &blk)
      super unless crud_methods.include? name.to_s
      raise invalid_operation name
    end

  end
end
