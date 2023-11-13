# frozen_string_literal: true

# ObjectInspector is the base namespace for all modules/classes related to the
# object_inspector gem.
module ObjectInspector
  # Accessor for the {ObjectInspector::Configuration} object.
  def self.configuration
    @configuration ||= Configuration.new
  end

  # @yieldparam configuration [ObjectInspector::Configuration]
  def self.configure
    yield(configuration)
  end

  # Reset the current configuration settings memoized by
  # {ObjectInspector.configuration}.
  def self.reset_configuration
    @configuration = Configuration.new
  end

  # ObjectInspector::Configuration stores the default configuration options for
  # the ObjectInspector gem. Modification of attributes is possible at any time,
  # and values will persist for the duration of the running process.
  #
  # :reek:TooManyInstanceVariables
  class Configuration
    attr_reader :formatter_class,
                :inspect_method_prefix,
                :default_scope,
                :wild_card_scope,
                :out_of_scope_placeholder,
                :presented_object_separator,
                :name_separator,
                :flags_separator,
                :issues_separator,
                :info_separator

    def initialize
      @formatter_class = TemplatingFormatter
      @inspect_method_prefix = "inspect"
      @default_scope = Scope.new(:self)
      @wild_card_scope = "all"
      @out_of_scope_placeholder = "*"
      @presented_object_separator = " #{[0x21E8].pack("U")} "
      @name_separator = " - "
      @flags_separator = " / "
      @issues_separator = " | "
      @info_separator = " | "
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

    def presented_object_separator=(value)
      @presented_object_separator = value.to_s.freeze
    end

    def name_separator=(value)
      @name_separator = value.to_s.freeze
    end

    def flags_separator=(value)
      @flags_separator = value.to_s.freeze
    end

    def issues_separator=(value)
      @issues_separator = value.to_s.freeze
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
