module ObjectInspector
  # ObjectInspector::BaseFormatter is an abstract base class that interfaces
  # with {ObjectInspector::Inspector} objects to combine the supplied
  # {#identification}, {#flags}, {#info}, and {#name} strings into a friendly
  # "inspect" String.
  #
  # @attr inspector [ObjectInspector::Inspector]
  class BaseFormatter
    attr_reader :inspector

    def initialize(inspector)
      @inspector = inspector
    end

    # Perform the formatting routine.
    #
    # @return [String]
    def call
      raise NotImplementedError
    end

    # Delegates to {Inspector#identification}.
    #
    # @return [String] if given
    def identification
      @identification ||= inspector.identification
    end

    # Delegates to {Inspector#flags}.
    #
    # @return [String] if given
    # @return [NilClass] if not given
    def flags
      @flags ||= inspector.flags
    end

    # Delegates to {Inspector#info}.
    #
    # @return [String] if given
    # @return [NilClass] if not given
    def info
      @info ||= inspector.info
    end

    # Delegates to {Inspector#name}.
    #
    # @return [String] if given
    # @return [NilClass] if not given
    def name
      @name ||= inspector.name
    end
  end
end
