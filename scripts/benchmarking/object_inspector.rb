# Play from the console with:
#   play scripts/benchmarking/object_inspector.rb

require "ostruct"
require "benchmark/ips"

inspector_klass = ObjectInspector::Inspector

OBJECT_WITH_FLAGS_AND_INFO_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO",
    name: "NAME")
OBJECT_WITH_FLAGS_AND_INFO ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO")
OBJECT_WITH_FLAGS_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    name: "NAME")
OBJECT_WITH_INFO_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO",
    name: "NAME")
OBJECT_WITH_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    name: "NAME")
OBJECT_WITH_FLAGS ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2")
OBJECT_WITH_INFO ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO")
OBJECT_WITH_BASE ||=
  OpenStruct.new(
    identification: "IDENTIFICATION")


puts "== Averaged ============================================================="
Benchmark.ips { |x|
  x.report(inspector_klass) {
    inspector_klass.inspect(OBJECT_WITH_FLAGS_AND_INFO_AND_NAME)
    inspector_klass.inspect(OBJECT_WITH_FLAGS_AND_INFO)
    inspector_klass.inspect(OBJECT_WITH_FLAGS_AND_NAME)
    inspector_klass.inspect(OBJECT_WITH_INFO_AND_NAME)
    inspector_klass.inspect(OBJECT_WITH_NAME)
    inspector_klass.inspect(OBJECT_WITH_FLAGS)
    inspector_klass.inspect(OBJECT_WITH_INFO)
    inspector_klass.inspect(OBJECT_WITH_BASE)
  }

  x.report("Ruby") {
    OBJECT_WITH_FLAGS_AND_INFO_AND_NAME.inspect
    OBJECT_WITH_FLAGS_AND_INFO.inspect
    OBJECT_WITH_FLAGS_AND_NAME.inspect
    OBJECT_WITH_INFO_AND_NAME.inspect
    OBJECT_WITH_NAME.inspect
    OBJECT_WITH_FLAGS.inspect
    OBJECT_WITH_INFO.inspect
    OBJECT_WITH_BASE.inspect
  }

  x.compare!
};
puts "== Done"
