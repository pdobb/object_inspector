# frozen_string_literal: true

# ObjectInspector::InspectBehaviors can be included into any object to override
# the default `#inspect` method for that object to instead call
# {ObjectInspector::Inspector.inspect}.
module ObjectInspector::InspectBehaviors
  # :reek:TooManyStatements

  # Calls {ObjectInspector::Inspector.inspect} on `self`, passing through any
  # keyword arguments.
  #
  # If building the gem inspect String raises a {StandardError}, records the
  # error via {ObjectInspector.record_error} and falls back to the ancestor
  # `#inspect` via `super` (Object / ActiveRecord / etc.).
  #
  # @return [String]
  def inspect(**)
    return super() if ObjectInspector.configuration.disabled?

    ObjectInspector::Inspector.inspect(self, **).tap {
      ObjectInspector.clear_error
    }
  rescue => ex
    ObjectInspector.record_error(ex, object: self)
    super()
  end

  # Like {#inspect} but:
  # - Ignores the enabled/disabled state of ObjectInspector
  # - Forces scope to `:all`
  #
  # This (the bang (!) version) is considered the "more dangerous" version of
  # {#inspect} since the `:all` scope may result in additional queries or extra
  # processing--depending on how the inspect hooks are setup.
  #
  # On {StandardError}, records the error and falls back to {#inspect} (which
  # then falls back to the original ancestor `#inspect` if needed).
  #
  # @return [String]
  def inspect!(**)
    ObjectInspector::Inspector.inspect(self, **, scope: :all).tap {
      ObjectInspector.clear_error
    }
  rescue => ex
    ObjectInspector.record_error(ex, object: self)

    inspect
  end

  private

  # :reek:UtilityFunction

  # Allow ActiveRecord::Core#pretty_print to produce the standard Pretty-printed
  # output (vs just straight #inspect String) when ObjectInspector is disabled.
  def custom_inspect_method_defined?
    ObjectInspector.configuration.enabled?
  end
end
