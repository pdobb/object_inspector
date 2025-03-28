# frozen_string_literal: true

# ObjectInspector::BaseFormatter is an abstract base class that interfaces
# with {ObjectInspector::Inspector} objects to combine the supplied
# {#identification}, {#flags}, {#info}, and {#name} strings into a friendly
# "inspect" String.
class ObjectInspector::BaseFormatter
  attr_reader :inspector

  # @param inspector [ObjectInspector::Inspector]
  def initialize(inspector)
    @inspector = inspector
  end

  # Perform the formatting routine.
  #
  # @return [String]
  def call
    raise(NotImplementedError)
  end

  # Delegates to {Inspector#wrapped_object_inspection_result}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def wrapped_object_inspection_result
    @wrapped_object_inspection_result ||=
      @inspector.wrapped_object_inspection_result
  end

  # Delegates to {Inspector#identification}.
  #
  # @return [String] if given
  def identification
    @identification ||= @inspector.identification
  end

  # Delegates to {Inspector#flags}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def flags
    @flags ||= @inspector.flags
  end

  # Delegates to {Inspector#issues}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def issues
    @issues ||= @inspector.issues
  end

  # Delegates to {Inspector#info}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def info
    @info ||= @inspector.info
  end

  # Delegates to {Inspector#name}.
  #
  # @return [String] if given
  # @return [NilClass] if not given
  def name
    @name ||= @inspector.name
  end
end
