module ObjectInspector
  # ObjectInspector::Scope defines a predicate method that matches {#name} and
  # responds with `true`. This is a prettier way to test for a given type of
  # "scope" within objects.
  #
  # @see ActiveSupport::StringInquirer
  #   http://api.rubyonrails.org/classes/ActiveSupport/StringInquirer.html
  #
  # @attr name [#to_s]
  class Scope
    attr_reader :name

    def initialize(name = :self)
      @name = String(name)
    end

    # Join the passed-in flags with the passed in separator.
    #
    # @param items [Array<#to_s>]
    # @param separator [#to_s] (ObjectInspector.flags_separator)
    def join_flags(flags, separator: ObjectInspector.flags_separator)
      Array(flags).join(separator)
    end

    # Join the passed-in items with the passed in separator.
    #
    # @param items [Array<#to_s>]
    # @param separator [#to_s] (ObjectInspector.info_separator)
    def join_info(items, separator: ObjectInspector.info_separator)
      Array(items).join(separator)
    end

  private

    def method_missing(method_name, *arguments)
      if method_name[-1] == "?"
        @name == method_name[0..-2]
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name[-1] == "?"
    end
  end
end
