# frozen_string_literal: true

# ObjectInspector::InspectBehaviors can be included into any object to override
# the default `#inspect` method for that object to instead call
# {ObjectInspector::Inspector.inspect}.
module ObjectInspector::InspectBehaviors
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
