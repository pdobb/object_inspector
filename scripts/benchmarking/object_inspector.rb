# frozen_string_literal: true

# Play from the console with:
#   play scripts/benchmarking/object_inspector.rb

require "ostruct"
require "benchmark/ips"

inspector_klass = ObjectInspector::Inspector

def object_with_flags_and_info_and_name
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO",
    name: "NAME")
end

def object_with_flags_and_info
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO")
end

def object_with_flags_and_name
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    name: "NAME")
end

def object_with_info_and_name
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO",
    name: "NAME")
end

def object_with_name
  OpenStruct.new(
    identification: "IDENTIFICATION",
    name: "NAME")
end

def object_with_flags
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2")
end

def object_with_info
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO")
end

def object_with_base
  OpenStruct.new(
    identification: "IDENTIFICATION")
end

puts "== Averaged ============================================================="
Benchmark.ips { |x|
  x.report(inspector_klass) {
    inspector_klass.inspect(object_with_flags_and_info_and_name)
    inspector_klass.inspect(object_with_flags_and_info)
    inspector_klass.inspect(object_with_flags_and_name)
    inspector_klass.inspect(object_with_info_and_name)
    inspector_klass.inspect(object_with_name)
    inspector_klass.inspect(object_with_flags)
    inspector_klass.inspect(object_with_info)
    inspector_klass.inspect(object_with_base)
  }

  x.report("Ruby") {
    object_with_flags_and_info_and_name.inspect
    object_with_flags_and_info.inspect
    object_with_flags_and_name.inspect
    object_with_info_and_name.inspect
    object_with_name.inspect
    object_with_flags.inspect
    object_with_info.inspect
    object_with_base.inspect
  }

  x.compare!
}
puts "== Done"
