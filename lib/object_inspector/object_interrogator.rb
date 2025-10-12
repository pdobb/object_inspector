# frozen_string_literal: true

# Collaborates with {#object} to return {#object}#{#method_name} if {#object}
# responds to {#method_name}.
#
# If {#object}#{#method_name} accepts the supplied `kwargs` then they are passed
# in as well. If not, then any supplied `kwargs` will be ignored.
class ObjectInspector::ObjectInterrogator
  attr_reader :object,
              :method_name,
              :kwargs

  def initialize(object:, method_name:, kwargs: {})
    @object = object
    @method_name = method_name
    @kwargs = kwargs
  end

  # @return [String, ...] Whatever type Object#{#method_name} returns.
  #
  # @raise [ArgumentError] If Object#{#method_name} has an unexpected method
  #   signature.
  def call
    return unless object_responds_to_method_name?

    if object.method(method_name).arity.zero?
      object.__send__(method_name)
    else
      call_with_kwargs
    end
  end

  private

  def call_with_kwargs
    object.__send__(method_name, **kwargs)
  rescue ArgumentError
    object.__send__(method_name)
  end

  # :reek:ManualDispatch
  # :reek:BooleanParameter

  def object_responds_to_method_name?(include_private: true)
    object.respond_to?(method_name, include_private)
  end
end
