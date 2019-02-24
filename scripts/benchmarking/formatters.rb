# frozen_string_literal: true

# Play from the console with:
#   play scripts/benchmarking/formatters.rb

require "ostruct"
require "benchmark/ips"

custom_formatter_klasses ||= []

formatter_klasses = [
  ObjectInspector::TemplatingFormatter,
  ObjectInspector::CombiningFormatter,
  *Array(custom_formatter_klasses)
]

INSPECTOR_WITH_FLAGS_AND_INFO_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO",
    name: "NAME")
INSPECTOR_WITH_FLAGS_AND_INFO ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    info: "INFO")
INSPECTOR_WITH_FLAGS_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2",
    name: "NAME")
INSPECTOR_WITH_INFO_AND_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO",
    name: "NAME")
INSPECTOR_WITH_NAME ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    name: "NAME")
INSPECTOR_WITH_FLAGS ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    flags: "FLAG1 | FLAG2")
INSPECTOR_WITH_INFO ||=
  OpenStruct.new(
    identification: "IDENTIFICATION",
    info: "INFO")
INSPECTOR_WITH_BASE ||=
  OpenStruct.new(
    identification: "IDENTIFICATION")

puts "== Averaged ============================================================="
Benchmark.ips { |x|
  formatter_klasses.each do |formatter_klass|
    x.report(formatter_klass) {
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_INFO_AND_NAME).call
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_INFO).call
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_NAME).call
      formatter_klass.new(INSPECTOR_WITH_INFO_AND_NAME).call
      formatter_klass.new(INSPECTOR_WITH_NAME).call
      formatter_klass.new(INSPECTOR_WITH_FLAGS).call
      formatter_klass.new(INSPECTOR_WITH_INFO).call
      formatter_klass.new(INSPECTOR_WITH_BASE).call
    }
  end

  x.compare!
}
puts "== Done"

puts "== Individualized ======================================================="
Benchmark.ips { |x|
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Info and Name") {
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_INFO_AND_NAME).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Info") {
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_INFO).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Name") {
      formatter_klass.new(INSPECTOR_WITH_FLAGS_AND_NAME).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Info and Name") {
      formatter_klass.new(INSPECTOR_WITH_INFO_AND_NAME).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Name") {
      formatter_klass.new(INSPECTOR_WITH_NAME).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags") {
      formatter_klass.new(INSPECTOR_WITH_FLAGS).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Info") {
      formatter_klass.new(INSPECTOR_WITH_INFO).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Base") {
      formatter_klass.new(INSPECTOR_WITH_BASE).call
    }
  end

  x.compare!
}
puts "== Done"
