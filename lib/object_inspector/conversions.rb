# frozen_string_literal: true

# ObjectInspector::Conversions defines conversion functions used by
# ObjectInspector.
module ObjectInspector::Conversions
  module_function

  # Convert the passed in value to an {ObjectInspector::Scope} object.
  # Just returns the passed in value if it already is an
  # {ObjectInspector::Scope} object.
  #
  # @return [ObjectInspector::Scope]
  #
  # :reek:UncommunicativeMethodName
  def Scope(value) # rubocop:disable Naming/MethodName
    case value
    when ObjectInspector::Scope
      value
    else
      ObjectInspector::Scope.new(value)
    end
  end
end
