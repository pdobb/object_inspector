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
    def self.object_method_prefix
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
    #   `#{object_method_prefix}_#{key}` (e.g. `inspect_flags`)
    # @return [NilClass] if not found in {#kargs} or {#object}
    def value(key:)
      result = kargs.fetch(key) { interrogate_object(key) }

      result.to_s if result
    end

    # @return [String] if {#object} responds to `#{object_method_prefix}_#{key}`
    #   (e.g. `inspect_flags`)
    # @return [NilClass] if not found on {#object}
    def interrogate_object(key)
      interrogator =
        ObjectInterrogator.new(
          object: object,
          method_name: build_method_name(key),
          kargs: object_method_keyword_arguments)

      interrogator.call
    end

    def build_method_name(key)
      "#{object_method_prefix}_#{key}"
    end

    def object_method_prefix
      self.class.object_method_prefix
    end

    def object_method_keyword_arguments
      {
        scope: scope,
      }
    end
  end
end
