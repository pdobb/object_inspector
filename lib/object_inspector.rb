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

  # ObjectInspector::Configuration stores the default configuration options for
  # the ObjectInspector gem. Modification of attributes is possible at any time,
  # and values will persist for the duration of the running process.
  class Configuration
    attr_reader :formatter_class,
                :inspect_method_prefix,
                :default_scope,
                :wild_card_scope,
                :out_of_scope_placeholder,
                :flags_separator,
                :info_separator

    def initialize
      @formatter_class = TemplatingFormatter
      @inspect_method_prefix = "inspect".freeze
      @default_scope = Scope.new(:self)
      @wild_card_scope = "all".freeze
      @out_of_scope_placeholder = "*".freeze
      @flags_separator = " / ".freeze
      @info_separator = " | ".freeze
    end

    def formatter_class=(value)
      unless value.is_a?(Class)
        raise TypeError, "Formatter must be a Class constant"
      end

      @formatter_class = value
    end

    def inspect_method_prefix=(value)
      @inspect_method_prefix = value.to_s.freeze
    end

    def default_scope=(value)
      @default_scope = Conversions.Scope(value)
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
