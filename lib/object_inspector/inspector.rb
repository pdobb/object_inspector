module ObjectInspector
  # ObjectInspector::Inspector organizes inspection of the associated {#object}.
  class Inspector
    attr_reader :object,
                :formatter_klass,
                :type,
                :kargs

    def self.object_method_prefix
      "inspect".freeze
    end

    # ObjectInspector::Inspector.inspect shortcuts the instantiation and {#to_s}
    # flow that would normally be required to use ObjectInspector::Inspector.
    #
    # @return [String]
    def self.inspect(object, **kargs)
      new(object, **kargs).to_s
    end

    def initialize(
          object,
          formatter: DefaultFormatter,
          type: :simple,
          **kargs)
      @object = object
      @formatter_klass = formatter
      @type = type
      @kargs = kargs
    end

    def to_s
      formatter.call
    end

    # @return [String]
    def identification
      (value(key: :identification) || object.class).to_s
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def flags
      value(key: :flags)
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def info
      value(key: :info)
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def name
      value(key: :name)
    end

  private

    def formatter
      formatter_klass.new(self)
    end

    # @return [String] if `key` is found in {#kargs} or if Object responds to
    #   `#{object_method_prefix}_#{key}` (e.g. `inspect_flags`)
    # @return [NilClass] if not found in {#kargs} or Object
    def value(key:)
      result =
        kargs.fetch(key) {
          interrogator =
            ObjectInterrogator.new(
              object: object,
              method_name: build_method_name(key),
              kargs: object_method_keyword_arguments)

          interrogator.call
        }

      result.to_s if result
    end

    def build_method_name(key)
      "#{object_method_prefix}_#{key}"
    end

    def object_method_prefix
      self.class.object_method_prefix
    end

    def object_method_keyword_arguments
      { type => true }
    end
  end
end
