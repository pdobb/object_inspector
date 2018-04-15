# ObjectInspector is the base namespace for all modules/classes related to the
# object_inspector gem.
module ObjectInspector
  class << self
    attr_writer :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    yield(configuration)
  end

  def self.reset_configuration
    @configuration = Configuration.new
  end

  class Configuration
    attr_reader :wild_card_scope,
                :out_of_scope_placeholder,
                :flags_separator,
                :info_separator,
                :inspect_method_prefix

    def initialize
      @wild_card_scope = "all".freeze
      @out_of_scope_placeholder = "*".freeze
      @flags_separator = " / ".freeze
      @info_separator = " | ".freeze
      @inspect_method_prefix = "inspect".freeze
    end

    def wild_card_scope=(value)
      @wild_card_scope = value.to_s.freeze
    end

    def out_of_scope_placeholder=(value)
      @out_of_scope_placeholder = value.to_s.freeze
    end

    def flags_separator=(value)
      @flags_separator = value.to_s.freeze
    end

    def info_separator=(value)
      @info_separator = value.to_s.freeze
    end

    def inspect_method_prefix=(value)
      @inspect_method_prefix = value.to_s.freeze
    end
  end
end

require "object_inspector/version"
require "object_inspector/conversions"
require "object_inspector/inspector"
require "object_inspector/scope"
require "object_inspector/inspectors_helper"
require "object_inspector/object_interrogator"
require "object_inspector/formatters/base_formatter"
require "object_inspector/formatters/combining_formatter"
require "object_inspector/formatters/templating_formatter"
