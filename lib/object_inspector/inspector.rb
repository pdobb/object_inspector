module ObjectInspector
  # ObjectInspector::Inspector organizes inspection of the associated {#object}
  # via the passed in options and via a {ObjectInspector::BaseFormatter}
  # instance.
  #
  # @attr object [Object] the object being inspected
  # @attr scope [Symbol] Object inspection type. For example:
  #   :self (default) -- Means: Only interrogate self; Don't interrogate
  #                      neighboring objects
  #   :all            -- Means: Interrogate self as well as neighboring objects
  #   <custom>        -- Any value that {#object} recognizes can mean anything
  #                      that makes sense for {#object}
  # @attr formatter [ObjectInspector::BaseFormatter] the formatter object to use
  #   for combining the output of into the inspect String
  # @attr kargs [Hash] options to be sent to {#object}
  class Inspector
    attr_reader :object,
                :scope,
                :formatter_klass,
                :kargs

    # The prefix for all methods called on {#object} for inspect
    # details/strings.
    def self.object_inspect_method_prefix
      "inspect".freeze
    end

    # Shortcuts the instantiation -> {#to_s} flow that would normally be
    # required to use ObjectInspector::Inspector.
    #
    # @return [String]
    def self.inspect(object, **kargs)
      new(object, **kargs).to_s
    end

    def initialize(
          object,
          scope: :self,
          formatter: TemplatingFormatter,
          **kargs)
      @object = object
      @formatter_klass = formatter
      @scope = "".respond_to?(:inquiry) ? scope.to_s.inquiry : scope.to_sym
      @kargs = kargs
    end

    # Generate the formatted inspect String.
    #
    # @return [String]
    def to_s
      formatter.call
    end

    # Core object identification details, such as the {#object} class name and
    # any core-level attributes.
    #
    # @return [String]
    def identification
      (value(key: :identification) || object.class).to_s
    end

    # Boolean flags/states applicable to {#object}.
    #
    # @return [String] if given
    # @return [NilClass] if not given
    def flags
      value(key: :flags)
    end

    # Informational details applicable to {#object}.
    #
    # @return [String] if given
    # @return [NilClass] if not given
    def info
      value(key: :info)
    end

    # The generally human-friendly unique identifier for {#object}.
    # @return [String] if given
    # @return [NilClass] if not given
    def name
      value(key: :name)
    end

  private

    def formatter
      formatter_klass.new(self)
    end

    # @return [String] if `key` is found in {#kargs} or if {#object} responds to
    #   `#{object_inspect_method_prefix}_#{key}` (e.g. `inspect_flags`)
    # @return [NilClass] if not found in {#kargs} or {#object}
    def value(key:)
      return_value =
        if (passed_in_value = kargs[key])
          evaluate_passed_in_value(passed_in_value)
        else
          interrogate_object_inspect_method(key)
        end

      return_value.to_s if return_value
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
    #   `#{object_inspect_method_prefix}_#{name}` (e.g. `inspect_flags`)
    # @return [NilClass] if not found on {#object}
    def interrogate_object_inspect_method(name)
      interrogate_object(
        method_name: build_inspet_method_name(name),
        kargs: object_method_keyword_arguments)
    end

    def interrogate_object(method_name:, kargs: {})
      interrogator =
        ObjectInterrogator.new(
          object: object,
          method_name: method_name,
          kargs: kargs)

      interrogator.call
    end

    def build_inspet_method_name(name)
      "#{object_inspect_method_prefix}_#{name}"
    end

    def object_inspect_method_prefix
      self.class.object_inspect_method_prefix
    end

    def object_method_keyword_arguments
      {
        scope: scope,
      }
    end
  end
end
