# frozen_string_literal: true

# ObjectInspector::InspectorsHelper can be included into any object to
# simplify the process of instantiating an ObjectInspector::Inspector and
# generating the inspection output.
module ObjectInspector::InspectorsHelper
  # Calls {ObjectInspector::Inspector.inspect} on the passed in `object`,
  # passing it the passed in `kwargs` (keyword arguments).
  #
  # @return [String]
  def inspect(**kwargs)
    return super() if ObjectInspector.configuration.disabled?

    ObjectInspector::Inspector.inspect(self, **kwargs)
  end

  private

  # :reek:UtilityFunction

  # Allow ActiveRecord::Core#pretty_print to produce the standard Pretty-printed
  # output (vs just straight #inspect String) when ObjectInspector is disabled.
  def custom_inspect_method_defined?
    ObjectInspector.configuration.enabled?
  end
end
