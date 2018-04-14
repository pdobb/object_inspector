# ObjectInspector is the base namespace for all modules/classes related to the
# object_inspector gem.
module ObjectInspector
  def self.flags_separator
    " / ".freeze
  end

  def self.info_separator
    " | ".freeze
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
