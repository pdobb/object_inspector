module ObjectInspector
  # ObjectInspector::Scope defines a predicate method that matches {#name} and
  # responds with `true`. This is a prettier way to test for a given type of
  # "scope" within objects.
  #
  # @see ActiveSupport::StringInquirer
  #   http://api.rubyonrails.org/classes/ActiveSupport/StringInquirer.html
  #
  # @attr names [Array<#to_s>]
  class Scope
    attr_reader :names

    def initialize(names = %w[self])
      @names = Array(names).map { |name| String(name) }
    end

    # Join the passed-in flags with the passed in separator.
    #
    # @param items [Array<#to_s>]
    # @param separator [#to_s] (ObjectInspector.configuration.flags_separator)
    def join_flags(flags,
                   separator: ObjectInspector.configuration.flags_separator)
      Array(flags).join(separator)
    end

    # Join the passed-in items with the passed in separator.
    #
    # @param items [Array<#to_s>]
    # @param separator [#to_s] (ObjectInspector.configuration.info_separator)
    def join_info(items,
                   separator: ObjectInspector.configuration.info_separator)
      Array(items).join(separator)
    end

  private

    def method_missing(method_name, *args, &block)
      if method_name[-1] == "?"
        scope_name = method_name[0..-2]
        evaluate_match(scope_name, &block)
      else
        super
      end
    end

    def evaluate_match(scope_name, &block)
      is_a_match = match?(scope_name)

      if block
        evaluate_block_if(is_a_match, &block)
      else
        is_a_match
      end
    end

    def evaluate_block_if(condition, &block)
      if condition
        block.call
      else
        ObjectInspector.configuration.out_of_scope_placeholder
      end
    end

    def match?(scope_name)
      any_names_match?(scope_name) ||
        wild_card_scope?
    end

    def wild_card_scope?
      @is_wild_card_scope ||=
        any_names_match?(ObjectInspector.configuration.wild_card_scope)
    end

    def any_names_match?(other_name)
      @names.any? { |name| name == other_name }
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name[-1] == "?" || super
    end
  end
end
