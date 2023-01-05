# frozen_string_literal: true

# Play from the console with:
#   play scripts/benchmarking/formatters.rb

require "benchmark/ips"

custom_formatter_klasses ||= []

formatter_klasses = [
  ObjectInspector::TemplatingFormatter,
  ObjectInspector::CombiningFormatter,
  *Array(custom_formatter_klasses)
]

MyObject ||=
  Struct.new(:identification, :flags, :info, :name, :issues) do
    def wrapped_object_inspection_result
    end
  end

def inspector_with_flags_and_info_and_name
  @inspector_with_flags_and_info_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO",
      name: "NAME")
end

def inspector_with_flags_and_info
  @inspector_with_flags_and_info ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO")
end

def inspector_with_flags_and_name
  @inspector_with_flags_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      name: "NAME")
end

def inspector_with_info_and_name
  @inspector_with_info_and_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      info: "INFO",
      name: "NAME")
end

def inspector_with_name
  @inspector_with_name ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      name: "NAME")
end

def inspector_with_flags
  @inspector_with_flags ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2")
end

def inspector_with_info
  @inspector_with_info ||=
    MyObject.new(
      identification: "IDENTIFICATION",
      info: "INFO")
end

def inspector_with_base
  @inspector_with_base ||=
    MyObject.new(
      identification: "IDENTIFICATION")
end

puts "== Averaged ============================================================="
Benchmark.ips { |x|
  formatter_klasses.each do |formatter_klass|
    x.report(formatter_klass) {
      formatter_klass.new(inspector_with_flags_and_info_and_name).call
      formatter_klass.new(inspector_with_flags_and_info).call
      formatter_klass.new(inspector_with_flags_and_name).call
      formatter_klass.new(inspector_with_info_and_name).call
      formatter_klass.new(inspector_with_name).call
      formatter_klass.new(inspector_with_flags).call
      formatter_klass.new(inspector_with_info).call
      formatter_klass.new(inspector_with_base).call
    }
  end

  x.compare!
}
puts "== Done"

puts "== Individualized ======================================================="
Benchmark.ips { |x|
  # rubocop:disable Style/CombinableLoops
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Info and Name") {
      formatter_klass.new(inspector_with_flags_and_info_and_name).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Info") {
      formatter_klass.new(inspector_with_flags_and_info).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags and Name") {
      formatter_klass.new(inspector_with_flags_and_name).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Info and Name") {
      formatter_klass.new(inspector_with_info_and_name).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Name") {
      formatter_klass.new(inspector_with_name).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Flags") {
      formatter_klass.new(inspector_with_flags).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Info") {
      formatter_klass.new(inspector_with_info).call
    }
  end
  formatter_klasses.each do |formatter_klass|
    x.report("#{formatter_klass} - Base") {
      formatter_klass.new(inspector_with_base).call
    }
  end
  # rubocop:enable Style/CombinableLoops

  x.compare!
}
puts "== Done"
