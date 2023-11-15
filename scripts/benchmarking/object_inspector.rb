# frozen_string_literal: true

# Play from the console with:
#   play scripts/benchmarking/object_inspector.rb

require "benchmark/ips"

inspector_klass = ObjectInspector::Inspector

MyObject = Struct.new(:identification, :flags, :info, :name)

def object_with_flags_and_info_and_name
  @object_with_flags_and_info_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO",
      name: "NAME")
end

def object_with_flags_and_info
  @object_with_flags_and_info ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO")
end

def object_with_flags_and_name
  @object_with_flags_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      name: "NAME")
end

def object_with_info_and_name
  @object_with_info_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      info: "INFO",
      name: "NAME")
end

def object_with_name
  @object_with_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      name: "NAME")
end

def object_with_flags
  @object_with_flags ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2")
end

def object_with_info
  @object_with_info ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      info: "INFO")
end

def object_with_base
  @object_with_base ||=
    MyObject.new(
      identification: "IDENTIFICATION")
end

puts "== Averaged ============================================================="
Benchmark.ips do |x|
  x.report(inspector_klass) do
    inspector_klass.inspect(object_with_flags_and_info_and_name)
    inspector_klass.inspect(object_with_flags_and_info)
    inspector_klass.inspect(object_with_flags_and_name)
    inspector_klass.inspect(object_with_info_and_name)
    inspector_klass.inspect(object_with_name)
    inspector_klass.inspect(object_with_flags)
    inspector_klass.inspect(object_with_info)
    inspector_klass.inspect(object_with_base)
  end

  x.report("Ruby") do
    object_with_flags_and_info_and_name.inspect
    object_with_flags_and_info.inspect
    object_with_flags_and_name.inspect
    object_with_info_and_name.inspect
    object_with_name.inspect
    object_with_flags.inspect
    object_with_info.inspect
    object_with_base.inspect
  end

  x.compare!
end
puts "== Done"
