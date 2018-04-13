# ObjectInspector is the base namespace for all modules/classes related to the
# object_inspector gem.
module ObjectInspector
  @@use_string_inquirers = nil

  def self.use_string_inquirers?
    if @@use_string_inquirers.nil?
      @@use_string_inquirers = !!defined?(ActiveSupport::StringInquirer)
    else
      @@use_string_inquirers
    end
  end
end

require "object_inspector/version"
require "object_inspector/inspector"
require "object_inspector/inspectors_helper"
require "object_inspector/object_interrogator"
require "object_inspector/formatters/base_formatter"
require "object_inspector/formatters/combining_formatter"
require "object_inspector/formatters/templating_formatter"
