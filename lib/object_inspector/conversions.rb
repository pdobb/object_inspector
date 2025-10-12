# frozen_string_literal: true

# Defines general conversion functions used by ObjectInspector.
module ObjectInspector::Conversions
  module_function

  # :reek:UncommunicativeMethodName

  # Convert the passed in value to an {ObjectInspector::Scope} object.
  # Just returns the passed in value if it already is an
  # {ObjectInspector::Scope} object.
  #
  # @example
  #   ObjectInspector::Conversions.Scope("test")
  #   # => <ObjectInspector::Scope :: ["test"]>
  #
  #   ObjectInspector::Conversions.Scope(
  #     ObjectInspector::Scope.new(:my_custom_scope),
  #   )
  #   # => <ObjectInspector::Scope :: ["my_custom_scope"]>
  #
  # @return [ObjectInspector::Scope]
  def Scope(value) # rubocop:disable Naming/MethodName
    case value
    when ObjectInspector::Scope
      value
    else
      ObjectInspector::Scope.new(value)
    end
  end
end
