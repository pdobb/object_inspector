module ObjectInspector
  # ObjectInspector::Scope defines a predicate method that matches {#name} and
  # responds with `true`. This is a prettier way to test for a given type of
  # "scope" within objects.
  #
  # (see http://api.rubyonrails.org/classes/ActiveSupport/StringInquirer.html)
  class Scope
    attr_reader :name

    def initialize(name = :self)
      @name = String(name)
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
