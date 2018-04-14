module ObjectInspector
  # ObjectInspector::Conversions defines conversion functions used by
  # ObjectInspector.
  module Conversions

  module_function

    # Convert the passed in value to an {ObjectInspector::Scope} object.
    # Just returns the pass in value if it already is an
    # {ObjectInspector::Scope} object.
    #
    # @return [ObjectInspector::Scope]
    def Scope(value)
      case value
      when ObjectInspector::Scope
        value
      else
        ObjectInspector::Scope.new(value)
      end
    end
  end
end
