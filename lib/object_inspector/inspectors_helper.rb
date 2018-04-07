module ObjectInspector
  # ObjectInspector::InspectorsHelper can be included into any object to
  # simplify the process of instantiating an ObjectInspector::Inspector and
  # generating the inspection output.
  module InspectorsHelper
    # @return [String]
    def inspect(object = self, **kargs)
      Inspector.inspect(object, **kargs)
    end
  end
end
