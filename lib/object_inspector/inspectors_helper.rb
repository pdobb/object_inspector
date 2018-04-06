module ObjectInspector
  # ObjectInspector::InspectorsHelper can be included into any object to
  # simplify the process of instantiating an ObjectInspector::Inspector and
  # generating the inspection output.
  module InspectorsHelper
    # @return [String]
    def inspect(object = self, **kargs)
      Inspector.new(object, **kargs).to_s
    end
  end
end
