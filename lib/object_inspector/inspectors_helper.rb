# frozen_string_literal: true

# ObjectInspector::InspectorsHelper can be included into any object to
# simplify the process of instantiating an ObjectInspector::Inspector and
# generating the inspection output.
module ObjectInspector::InspectorsHelper
  # Calls {ObjectInspector::Inspector.inspect} on the passed in `object`,
  # passing it the passed in `kwargs` (keyword arguments).
  #
  # @return [String]
  def inspect(object = self, ...)
    ObjectInspector::Inspector.inspect(object, ...)
  end
end
