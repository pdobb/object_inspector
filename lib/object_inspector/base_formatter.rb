module ObjectInspector
  # ObjectInspector::BaseFormatter is an abstract base class that interfaces
  # with ObjectInspector::Inspector objects to combine the supplied
  # {#identification}, {#flags}, {#info}, and {#name} strings into a friendly
  # "inspect" String.
  #
  # @attr inspector [ObjectInspector::Inspector] the object from which Strings
  #   are queried for building the formatted inspect String
  class BaseFormatter
    def initialize(inspector)
      @inspector = inspector
    end

    # @return [String]
    def call
      raise NotImplementedError
    end

    # @return [String] if given
    def identification
      @inspector.identification
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def flags
      @inspector.flags
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def info
      @inspector.info
    end

    # @return [String] if given
    # @return [NilClass] if not given
    def name
      @inspector.name
    end

  private

    def combine_strings
      strings.join
    end

    # Override in subclasses as needed.
    def strings
      [
        build_identification_string,
        build_flags_string,
        build_info_string,
        build_name_string,
      ].compact
    end

    def build_identification_string(*)
      raise NotImplementedError
    end

    def build_flags_string(*)
      raise NotImplementedError
    end

    def build_info_string(*)
      raise NotImplementedError
    end

    def build_name_string(*)
      raise NotImplementedError
    end
  end
end
