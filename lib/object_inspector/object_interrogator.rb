# frozen_string_literal: true

module ObjectInspector
  # ObjectInspector::ObjectInterrogator collaborates with {#object} to return
  # Object#{#method_name} if {#object} responds to the method.
  #
  # If Object#{#method_name} accepts the supplied {#kargs} then they are passed
  # in as well. If not, then any supplied {#kargs} will be ignored.
  class ObjectInterrogator
    attr_reader :object,
                :method_name,
                :kargs

    def initialize(object:, method_name:, kargs: {})
      @object = object
      @method_name = method_name
      @kargs = kargs
    end

    # @return [String, ...] whatever type Object#{#method} returns
    #
    # @raise [ArgumentError] if Object#{#method} has an unexpected method
    #   signature
    def call
      return unless object_responds_to_method_name?

      if object.method(method_name).arity != 0
        call_with_kargs
      else
        object.send(method_name)
      end
    end

    private

    def call_with_kargs
      object.send(method_name, **kargs)
    rescue ArgumentError
      object.send(method_name)
    end

    def object_responds_to_method_name?(include_private: true)
      object.respond_to?(method_name, include_private)
    end
  end
end
