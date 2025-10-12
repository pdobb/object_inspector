# frozen_string_literal: true

# :reek:RepeatedConditional
# :reek:TooManyMethods
# rubocop:disable Metrics/ClassLength

# Specializes on {ObjectInspector::BaseFormatter} to return the standard/default
# inspect output format using String templates.
#
# @attr (see BaseFormatter)
class ObjectInspector::TemplatingFormatter < ObjectInspector::BaseFormatter
  # Named String templates. Used by the build_* methods, these templates
  # determine the format of the built output Strings.
  def self.templates
    @templates ||= {
      base: "<%s>",
      name: "<%s :: %s>",
      issues_and_name: "<%s !!%s!! :: %s>",
      flags_and_name: "<%s(%s) :: %s>",
      info_and_name: "<%s %s :: %s>",
      issues_and_info_and_name: "<%s !!%s!! %s :: %s>",
      flags_and_info: "<%s(%s) %s>",
      flags_and_issues: "<%s(%s) !!%s!!>",
      issues_and_info: "<%s !!%s!! %s>",
      flags_and_issues_and_info: "<%s(%s) !!%s!! %s>",
      flags_and_issues_and_name: "<%s(%s) !!%s!! :: %s>",
      flags_and_info_and_name: "<%s(%s) %s :: %s>",
      flags_and_issues_and_info_and_name: "<%s(%s) !!%s!! %s :: %s>",
      flags: "<%s(%s)>",
      issues: "<%s !!%s!!>",
      info: "<%s %s>",
    }.freeze
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

  def build_string # rubocop:disable Metrics/MethodLength
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
    template_for(:flags_and_issues_and_info_and_name) %
      [identification, flags, issues, info, name]
  end

  def build_string_with_flags_and_issues_and_name
    template_for(:flags_and_issues_and_name) %
      [identification, flags, issues, name]
  end

  def build_string_with_flags_and_info_and_name
    template_for(:flags_and_info_and_name) %
      [identification, flags, info, name]
  end

  def build_string_with_issues_and_info_and_name
    template_for(:issues_and_info_and_name) %
      [identification, issues, info, name]
  end

  def build_string_with_flags_and_issues_and_info
    template_for(:flags_and_issues_and_info) %
      [identification, flags, issues, info]
  end

  def build_string_with_flags_and_issues
    template_for(:flags_and_issues) % [identification, flags, issues]
  end

  def build_string_with_flags_and_info
    template_for(:flags_and_info) % [identification, flags, info]
  end

  def build_string_with_flags_and_name
    template_for(:flags_and_name) % [identification, flags, name]
  end

  def build_string_with_issues_and_info
    template_for(:issues_and_info) % [identification, issues, info]
  end

  def build_string_with_issues_and_name
    template_for(:issues_and_name) % [identification, issues, name]
  end

  def build_string_with_info_and_name
    template_for(:info_and_name) % [identification, info, name]
  end

  def build_string_with_flags
    template_for(:flags) % [identification, flags]
  end

  def build_string_with_issues
    template_for(:issues) % [identification, issues]
  end

  def build_string_with_info
    template_for(:info) % [identification, info]
  end

  def build_string_with_name
    template_for(:name) % [identification, name]
  end

  def build_base_string
    template_for(:base) % [identification]
  end

  def template_for(name)
    self.class.templates.fetch(name)
  end
end

# rubocop:enable Metrics/ClassLength
