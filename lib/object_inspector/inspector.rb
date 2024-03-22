# frozen_string_literal: true

# ObjectInspector::Inspector organizes inspection of the associated {#object}
# via the passed in options and via an {ObjectInspector::BaseFormatter}
# instance.
#
# :reek:TooManyMethods
class ObjectInspector::Inspector
  attr_reader :object

  # Shortcuts the instantiation -> {#to_s} flow that would normally be
  # required to use ObjectInspector::Inspector.
  #
  # @return [String]
  def self.inspect(...)
    new(...).to_s
  end

  # @param object [Object] the object being inspected
  # @param scope [Symbol] Object inspection type. For example:
  #   :self (default) -- Means: Only interrogate self. Don't visit neighbors.
  #   <custom>        -- Anything else that makes sense for {#object} to key
  #                      on
  # @param formatter [ObjectInspector::BaseFormatter]
  #   (ObjectInspector.configuration.formatter) the formatter object type
  #   to use for formatting the inspect String
  # @param kwargs [Hash] options to be sent to {#object} via the
  #   {ObjectInspector::ObjectInterrogator} when calling the `inspect_*`
  #   methods
  #
  # :reek:DuplicateMethodCall (ObjectInspecto.configuration)
  def initialize(
        object,
        scope: ObjectInspector.configuration.default_scope,
        formatter: ObjectInspector.configuration.formatter_class,
        **kwargs)
    @object = object
    @scope = ObjectInspector::Conversions.Scope(scope)
    @formatter_klass = formatter
    @kwargs = kwargs
  end

  # Generate the formatted inspect String.
  #
  # @return [String]
  def to_s
    formatter.call
  end

  # Generate the inspect String for the wrapped object, if present.
  #
  # @return [String] if {#object_is_a_wrapper?}
  # @return [NilClass] if not {#object_is_a_wrapper?}
  def wrapped_object_inspection_result
    return unless object_is_a_wrapper?

    self.class.inspect(
      extract_wrapped_object,
      scope: @scope,
      formatter: @formatter_klass,
      kwargs: @kwargs)
  end

  # Core object identification details, such as the {#object} class name and
  # any core-level attributes.
  #
  # @return [String]
  def identification
    (value(key: :identification) || @object.class).to_s
  end

  # Boolean flags/states applicable to {#object}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def flags
    value(key: :flags)
  end

  # Issues/Warnings applicable to {#object}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def issues
    value(key: :issues)
  end

  # Informational details applicable to {#object}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def info
    value(key: :info)
  end

  # A human-friendly identifier for {#object}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def name
    key = :name

    if @kwargs.key?(key)
      value(key: key)
    else
      interrogate_object_inspect_method(key) ||
        interrogate_object(
          method_name: :display_name, kwargs: object_method_keyword_arguments)
    end
  end

  private

  def formatter
    @formatter_klass.new(self)
  end

  # @return [String] if `key` is found in {#kwargs} or if {#object} responds to
  #   `#{object_inspection_method_name}` (e.g. `inspect_flags`)
  # @return [NilClass] if not found in {#kwargs} or {#object}
  def value(key:)
    return_value =
      if @kwargs.key?(key)
        evaluate_passed_in_value(@kwargs[key])
      else
        interrogate_object_inspect_method(key)
      end

    return_value&.to_s
  end

  # Call `value` on {#object} if it responds to it and the result is not nil,
  # else just return `value`.
  #
  # @return [#to_s] if {#object} responds to `value` and if the call result
  #   isn't nil
  # @return [#nil] if {#object} doesn't respond to `value` or if the call
  #   result is nil
  def evaluate_passed_in_value(value)
    if value.is_a?(Symbol)
      interrogate_object(method_name: value) || value
    else
      value
    end
  end

  # Attempt to call `inspect_*` on {#object} based on the passed in `name`.
  #
  # @return [String] if {#object} responds to
  #   `#{object_inspection_method_name}` (e.g. `inspect_flags`)
  # @return [NilClass] if not found on {#object}
  def interrogate_object_inspect_method(
        name,
        prefix: ObjectInspector.configuration.inspect_method_prefix)
    interrogate_object(
      method_name: object_inspection_method_name(name, prefix: prefix),
      kwargs: object_method_keyword_arguments)
  end

  def interrogate_object(method_name:, kwargs: {})
    interrogator =
      ObjectInspector::ObjectInterrogator.new(
        object: @object,
        method_name: method_name,
        kwargs: kwargs)

    interrogator.call
  end

  # :reek:UtilityFunction
  def object_inspection_method_name(
        name,
        prefix: ObjectInspector.configuration.inspect_method_prefix)
    "#{prefix}_#{name}"
  end

  def object_method_keyword_arguments
    {
      scope: @scope,
    }
  end

  def extract_wrapped_object
    @object.to_model
  end

  # :reek:ManualDispatch
  def object_is_a_wrapper?
    @object.respond_to?(:to_model) &&
      @object.to_model != @object
  end
end
