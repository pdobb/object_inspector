module ObjectInspector
  # ObjectInspector::CombiningFormatter implements
  # {ObjectInspector::BaseFormatter} to return the standard/default inspect
  # output format by combining Strings.
  #
  # @attr (see BaseFormatter)
  class CombiningFormatter < BaseFormatter
    # Perform the formatting routine.
    #
    # @return [String]
    def call
      "<#{combine_strings}>"
    end

  private

    def combine_strings
      strings.join
    end

    # Override in subclasses as needed.
    def strings
      [
        build_identification_string,
        build_flags_string,
        build_info_string,
        build_name_string,
      ].compact
    end

    def build_identification_string
      identification.to_s
    end

    def build_flags_string
      "(#{flags.to_s.upcase})" if flags
    end

    def build_info_string
      " #{info}" if info
    end

    def build_name_string
      " :: #{name}" if name
    end
  end
end
