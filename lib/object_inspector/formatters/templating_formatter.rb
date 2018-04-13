module ObjectInspector
  # ObjectInspector::TemplatingFormatter implements
  # {ObjectInspector::BaseFormatter} to return the standard/default inspect
  # output format via String templates.
  #
  # @attr (see BaseFormatter)
  class TemplatingFormatter < BaseFormatter
    def self.base_template
      @base_template ||= "<%s>".freeze
    end

    def self.name_template
      @name_template ||= "<%s :: %s>".freeze
    end

    def self.flags_and_name_template
      @flags_and_name_template ||= "<%s(%s) :: %s>".freeze
    end

    def self.info_and_name_template
      @info_and_name_template ||= "<%s %s :: %s>".freeze
    end

    def self.flags_and_info_template
      @flags_and_info_template ||= "<%s(%s) %s>".freeze
    end

    def self.flags_and_info_and_name_template
      @flags_and_info_and_name_template ||= "<%s(%s) %s :: %s>".freeze
    end

    def self.flags_template
      @flags_template ||= "<%s(%s)>".freeze
    end

    def self.info_template
      @info_template ||= "<%s %s>".freeze
    end

    # Perform the formatting routine.
    #
    # @return [String]
    def call
      if wrapped_object_inspection
        build_wrapped_object_string
      else
        build_string
      end
    end

  private

    def build_wrapped_object_string
      "#{build_string} #{RIGHT_ARROW_ICON} #{wrapped_object_inspection}"
    end

    def build_string
      if flags
        if info
          if name
            build_flags_and_info_and_name_string
          else
            build_flags_and_info_string
          end
        elsif name
          build_flags_and_name_string
        else
          build_flags_string
        end
      elsif info
        if name
          build_info_and_name_string
        else
          build_info_string
        end
      elsif name
        build_name_string
      else
        build_base_string
      end
    end

    def build_flags_and_info_and_name_string
      self.class.flags_and_info_and_name_template % [
        identification,
        flags,
        info,
        name
      ]
    end

    def build_flags_and_info_string
      self.class.flags_and_info_template % [
        identification,
        flags,
        info
      ]
    end

    def build_flags_and_name_string
      self.class.flags_and_name_template % [
        identification,
        flags,
        name
      ]
    end

    def build_info_and_name_string
      self.class.info_and_name_template % [
        identification,
        info,
        name
      ]
    end

    def build_name_string
      self.class.name_template % [
        identification,
        name
      ]
    end

    def build_flags_string
      self.class.flags_template % [
        identification,
        flags
      ]
    end

    def build_info_string
      self.class.info_template % [
        identification,
        info
      ]
    end

    def build_base_string
      self.class.base_template % [
        identification
      ]
    end
  end
end
