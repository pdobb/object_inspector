module ObjectInspector
  # ObjectInspector::DefaultFormatter implements ObjectInspector::BaseFormatter
  # to return a standard/default inspect output format.
  class DefaultFormatter < BaseFormatter
    def call
      "<#{combine_strings}>"
    end

  private

    def build_identification_string
      identification.to_s
    end

    def build_flags_string
      "[#{flags.to_s.upcase}]" if flags
    end

    def build_info_string
      " (#{info})" if info
    end

    def build_name_string
      " :: #{name}" if name
    end
  end
end
