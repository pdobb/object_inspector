# frozen_string_literal: true

# Run from the IRB console with:
#   load "script/benchmarking/formatters.rb"

require "benchmark/ips"

CUSTOM_FORMATTER_CLASSES ||= []

formatter_classes = [
  ObjectInspector::TemplatingFormatter,
  ObjectInspector::CombiningFormatter,
  *Array(CUSTOM_FORMATTER_CLASSES),
]

MyObject =
  Struct.new(:identification, :flags, :issues, :info, :name) do
    def wrapped_object_inspection_result
    end
  end

def object_with_flags_and_issues_and_info_and_name
  @object_with_flags_and_issues_and_info_and_name ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      issues: "ISSUE1",
      info: "INFO",
      name: "NAME"
    })
end

def inspector_with_flags_and_info_and_name
  @inspector_with_flags_and_info_and_name ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO",
      name: "NAME"
    })
end

def inspector_with_flags_and_info
  @inspector_with_flags_and_info ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      info: "INFO"
    })
end

def inspector_with_flags_and_name
  @inspector_with_flags_and_name ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2",
      name: "NAME"
    })
end

def inspector_with_info_and_name
  @inspector_with_info_and_name ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      info: "INFO",
      name: "NAME"
    })
end

def inspector_with_name
  @inspector_with_name ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      name: "NAME"
    })
end

def inspector_with_flags
  @inspector_with_flags ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      flags: "FLAG1 | FLAG2"
    })
end

def inspector_with_info
  @inspector_with_info ||=
    MyObject.new({
      identification: "IDENTIFICATION",
      info: "INFO"
    })
end

def inspector_with_base
  @inspector_with_base ||=
    MyObject.new({
      identification: "IDENTIFICATION"
    })
end

def ruby_version = @ruby_version ||= `ruby -v | awk '{ print $2 }'`.strip
puts("Reporting for: Ruby v#{ruby_version}\n\n")

puts("== Averaged ============================================================")
Benchmark.ips do |x|
  formatter_classes.each do |formatter_class|
    x.report(formatter_class) {
      formatter_class.new(object_with_flags_and_issues_and_info_and_name).call
      formatter_class.new(inspector_with_flags_and_info_and_name).call
      formatter_class.new(inspector_with_flags_and_info).call
      formatter_class.new(inspector_with_flags_and_name).call
      formatter_class.new(inspector_with_info_and_name).call
      formatter_class.new(inspector_with_name).call
      formatter_class.new(inspector_with_flags).call
      formatter_class.new(inspector_with_info).call
      formatter_class.new(inspector_with_base).call
    }
  end

  x.compare!
end
puts("== Done ================================================================")

puts("== Individualized ======================================================")
Benchmark.ips do |x|
  # rubocop:disable Style/CombinableLoops
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Flags and Issues and Info and Name") {
      formatter_class.new(object_with_flags_and_issues_and_info_and_name).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Flags and Info and Name") {
      formatter_class.new(inspector_with_flags_and_info_and_name).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Flags and Info") {
      formatter_class.new(inspector_with_flags_and_info).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Flags and Name") {
      formatter_class.new(inspector_with_flags_and_name).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Info and Name") {
      formatter_class.new(inspector_with_info_and_name).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Name") {
      formatter_class.new(inspector_with_name).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Flags") {
      formatter_class.new(inspector_with_flags).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Info") {
      formatter_class.new(inspector_with_info).call
    }
  end
  formatter_classes.each do |formatter_class|
    x.report("#{formatter_class} - Base") {
      formatter_class.new(inspector_with_base).call
    }
  end
  # rubocop:enable Style/CombinableLoops

  x.compare!
end
puts("== Done ================================================================")
