# frozen_string_literal: true

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
      if wrapped_object_inspection_result
        build_wrapped_object_string
      else
        build_string
      end
    end

    private

    def build_wrapped_object_string
      "#{build_string} "\
      "#{ObjectInspector.configuration.presented_object_separator} "\
      "#{wrapped_object_inspection_result}"
    end

    def build_string
      "<#{combine_strings}>"
    end

    def combine_strings
      strings.join
    end

    # Override in subclasses as needed.
    def strings
      [
        build_identification_string,
        build_flags_string,
        build_info_string,
        build_name_string
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
