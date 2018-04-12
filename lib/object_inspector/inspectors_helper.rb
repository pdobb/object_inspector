module ObjectInspector
  # ObjectInspector::InspectorsHelper can be included into any object to
  # simplify the process of instantiating an ObjectInspector::Inspector and
  # generating the inspection output.
  module InspectorsHelper
    DEFAULT_SCOPE =
      if "".respond_to?(:inquiry)
        "self".inquiry.freeze
      else
        :self
      end

    # Calls {ObjectInspector::Inspector.inspect} on the passed in `object`,
    # passing it the passed in `kargs` (keyword arguments).
    #
    # @return [String]
    def inspect(object = self,
                scope: DEFAULT_SCOPE,
                **kargs)
      Inspector.inspect(object, scope: scope, **kargs)
    end
  end
end
