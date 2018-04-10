require "object_inspector/version"

# ObjectInspector is the base namespace for all modules/classes related to the
# object_inspector gem.
module ObjectInspector
  autoload :Inspector, "object_inspector/inspector"
  autoload :ObjectInterrogator, "object_inspector/object_interrogator"
  autoload :BaseFormatter, "object_inspector/base_formatter"
  autoload :DefaultFormatter, "object_inspector/default_formatter"
  autoload :InspectorsHelper, "object_inspector/inspectors_helper"
end
