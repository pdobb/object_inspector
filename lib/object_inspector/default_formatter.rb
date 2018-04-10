module ObjectInspector
  # ObjectInspector::DefaultFormatter implements
  # {ObjectInspector::BaseFormatter} to return a standard/default inspect output
  # format.
  #
  # @attr (see BaseFormatter)
  class DefaultFormatter < BaseFormatter
    # Perform the formatting routine.
    #
    # @return [String]
    def call
      "<#{combine_strings}>"
    end

  private

    def build_identification_string(identification = self.identification)
      identification.to_s
    end

    def build_flags_string(flags = self.flags)
      "[#{flags.to_s.upcase}]" if flags
    end

    def build_info_string(info = self.info)
      " (#{info})" if info
    end

    def build_name_string(name = self.name)
      " :: #{name}" if name
    end
  end
end
