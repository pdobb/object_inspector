# frozen_string_literal: true

# ObjectInspector::InspectorsHelper can be included into any object to
# simplify the process of instantiating an ObjectInspector::Inspector and
# generating the inspection output.
module ObjectInspector::InspectorsHelper
  # Calls {ObjectInspector::Inspector.inspect} on the passed in `object`,
  # passing through any keyword arguments.
  #
  # @return [String]
  def inspect(object = self, **)
    ObjectInspector::Inspector.inspect(object, **)
  end

  # Like {#inspect} but forces scope to `:all`. This (the bang (!) version) is
  # considered the "more dangerous" version of {#inspect} in the sense that the
  # `:all` scope may result in additional queries or extra processing--depending
  # on how the inspect hooks are setup.
  #
  # @return [String]
  def inspect!(object = self, **)
    ObjectInspector::Inspector.inspect(object, **, scope: :all)
  end
end
