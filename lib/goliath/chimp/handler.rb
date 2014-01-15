module Goliath::Chimp
  module Handler
    #
    # This handler mixin is designed to handle ONLY the
    # designated crud methods. Define your specific handler's
    # behavior and this mixin will take care of the validation 
    # and response behavior of any missing methods.
    #
    # Example:
    #
    # class SimpleHandler
    #   include Goliath::Chimp::Handler
    #
    #   def create doc
    #     # insert a record into the database
    #   end
    #
    #   def retrieve id
    #     # retrieve a record from the database
    #   end
    # end
    #
    # begin
    #   SimpleHandler.new.delete 'id'
    #G rescue Goliath::Validation::Error => e
    #   [e.status_code, {}, { error: e.message }
    # end
    # #=> [405, {}, {:error=>"Operation delete not allowed for SimpleHandler. Valid operations are ["create", "retrieve"]"}]
    #
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
