# frozen_string_literal: true

module ObjectInspector
  # ObjectInspector::TemplatingFormatter implements
  # {ObjectInspector::BaseFormatter} to return the standard/default inspect
  # output format via String templates.
  #
  # @attr (see BaseFormatter)
  class TemplatingFormatter < BaseFormatter
    def self.base_template
      @base_template ||= "<%s>"
    end

    def self.name_template
      @name_template ||= "<%s :: %s>"
    end

    def self.issues_and_name_template
      @issues_and_name_template ||= "<%s !!%s!! :: %s>"
    end

    def self.flags_and_name_template
      @flags_and_name_template ||= "<%s(%s) :: %s>"
    end

    def self.info_and_name_template
      @info_and_name_template ||= "<%s %s :: %s>"
    end

    def self.issues_and_info_and_name_template
      @issues_and_info_and_name_template ||= "<%s !!%s!! %s :: %s>"
    end

    def self.flags_and_info_template
      @flags_and_info_template ||= "<%s(%s) %s>"
    end

    def self.flags_and_issues_template
      @flags_and_issues_template ||= "<%s(%s) !!%s!!>"
    end

    def self.issues_and_info_template
      @issues_and_info_template ||= "<%s !!%s!! %s>"
    end

    def self.flags_and_issues_and_info_template
      @flags_and_issues_and_info_template ||= "<%s(%s) !!%s!! %s>"
    end

    def self.flags_and_issues_and_name_template
      @flags_and_issues_and_name_template ||= "<%s(%s) !!%s!! :: %s>"
    end

    def self.flags_and_info_and_name_template
      @flags_and_info_and_name_template ||= "<%s(%s) %s :: %s>"
    end

    def self.flags_and_issues_and_info_and_name_template
      @flags_and_issues_and_info_and_name_template ||=
        "<%s(%s) !!%s!! %s :: %s>"
    end

    def self.flags_template
      @flags_template ||= "<%s(%s)>"
    end

    def self.issues_template
      @issues_template ||= "<%s !!%s!!>"
    end

    def self.info_template
      @info_template ||= "<%s %s>"
    end

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

    # rubocop:disable Metrics/MethodLength
    def build_string
      if flags
        build_string_with_flags_and_maybe_issues_and_info_and_name
      elsif issues
        build_string_with_issues_and_maybe_info_and_name
      elsif info
        build_string_with_info_and_maybe_name
      elsif name
        build_string_with_name
      else
        build_base_string
      end
    end
    # rubocop:enable Metrics/MethodLength

    def build_string_with_flags_and_maybe_issues_and_info_and_name
      if issues
        build_string_with_flags_and_issues_and_maybe_info_and_name
      elsif info
        build_string_with_flags_and_info_and_maybe_name
      elsif name
        build_string_with_flags_and_name
      else
        build_string_with_flags
      end
    end

    def build_string_with_flags_and_issues_and_maybe_info_and_name
      if info
        build_string_with_flags_and_issues_and_info_and_maybe_name
      elsif name
        build_string_with_flags_and_issues_and_name
      else
        build_string_with_flags_and_issues
      end
    end

    def build_string_with_flags_and_issues_and_info_and_maybe_name
      if name
        build_string_with_flags_and_issues_and_info_and_name
      else
        build_string_with_flags_and_issues_and_info
      end
    end

    def build_string_with_issues_and_maybe_info_and_name
      if info
        build_string_with_issues_and_info_and_maybe_name
      elsif name
        build_string_with_issues_and_name
      else
        build_string_with_issues
      end
    end

    def build_string_with_issues_and_info_and_maybe_name
      if name
        build_string_with_issues_and_info_and_name
      else
        build_string_with_issues_and_info
      end
    end

    def build_string_with_flags_and_info_and_maybe_name
      if name
        build_string_with_flags_and_info_and_name
      else
        build_string_with_flags_and_info
      end
    end

    def build_string_with_info_and_maybe_name
      if name
        build_string_with_info_and_name
      else
        build_string_with_info
      end
    end

    def build_string_with_flags_and_issues_and_info_and_name
      self.class.flags_and_issues_and_info_and_name_template %
        [identification, flags, issues, info, name]
    end

    def build_string_with_flags_and_issues_and_name
      self.class.flags_and_issues_and_name_template %
        [identification, flags, issues, name]
    end

    def build_string_with_flags_and_info_and_name
      self.class.flags_and_info_and_name_template %
        [identification, flags, info, name]
    end

    def build_string_with_issues_and_info_and_name
      self.class.issues_and_info_and_name_template %
        [identification, issues, info, name]
    end

    def build_string_with_flags_and_issues_and_info
      self.class.flags_and_issues_and_info_template %
        [identification, flags, issues, info]
    end

    def build_string_with_flags_and_issues
      self.class.flags_and_issues_template % [identification, flags, issues]
    end

    def build_string_with_flags_and_info
      self.class.flags_and_info_template % [identification, flags, info]
    end

    def build_string_with_flags_and_name
      self.class.flags_and_name_template % [identification, flags, name]
    end

    def build_string_with_issues_and_info
      self.class.issues_and_info_template % [identification, issues, info]
    end

    def build_string_with_issues_and_name
      self.class.issues_and_name_template % [identification, issues, name]
    end

    def build_string_with_info_and_name
      self.class.info_and_name_template % [identification, info, name]
    end

    def build_string_with_flags
      self.class.flags_template % [identification, flags]
    end

    def build_string_with_issues
      self.class.issues_template % [identification, issues]
    end

    def build_string_with_info
      self.class.info_template % [identification, info]
    end

    def build_string_with_name
      self.class.name_template % [identification, name]
    end

    def build_base_string
      self.class.base_template % [identification]
    end
  end
end
