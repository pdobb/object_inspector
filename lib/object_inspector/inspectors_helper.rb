module ObjectInspector
  # ObjectInspector::InspectorsHelper can be included into any object to
  # simplify the process of instantiating an ObjectInspector::Inspector and
  # generating the inspection output.
  module InspectorsHelper
    # Calls {Inspector.inspect} on the passed in `object`, passing it the passed
    # in `kargs` (keyword arguments).
    #
    # @return [String]
    def inspect(object = self, **kargs)
      Inspector.inspect(object, **kargs)
    end
  end
end
