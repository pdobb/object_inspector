# frozen_string_literal: true

require "test_helper"

class ObjectInspector::InterrogateObjectTest < Minitest::Spec
  describe ".call" do
    subject { ObjectInspector::InterrogateObject }

    given "an Object with no keyword Arguments" do
      let(:object) { SimpleTestObject.new }

      given "a public method_name" do
        let(:method_name) { :example_method }

        it "returns the expected result" do
          result = subject.call(object, method_name:)
          _(result).must_equal("a")
        end
      end

      given "a private method_name" do
        let(:method_name) { :example_private_method }

        it "returns the expected result" do
          result = subject.call(object, method_name:)
          _(result).must_equal("b")
        end
      end

      given "an invalid method_name" do
        let(:method_name) { :invalid_method }

        it "returns nil" do
          result = subject.call(object, method_name:)
          _(result).must_be_nil
        end
      end
    end

    given "an Object with all optional keyword Arguments" do
      let(:object) { AllOptionalKeywordArgumentsTestObject.new }
      let(:method_name) { :example_method }

      given "a valid keyword argument" do
        let(:kwargs) { { a: "a" } }

        it "returns the expected result" do
          result = subject.call(object, method_name:, kwargs:)
          _(result).must_equal(["a", 2])
        end
      end

      given "an invalid keyword argument" do
        let(:kwargs) { { invalid_kwarg: 1 } }

        it "returns the expected result" do
          result = subject.call(object, method_name:, kwargs:)
          _(result).must_equal([1, 2])
        end
      end

      given "no keyword arguments" do
        let(:kwargs) { {} }

        it "returns the expected result" do
          result = subject.call(object, method_name:, kwargs:)
          _(result).must_equal([1, 2])
        end
      end
    end

    given "an Object with some optional keyword Arguments" do
      let(:object) { SomeOptionalKeywordArgumentsTestObject.new }
      let(:method_name) { :example_method }

      given "a missing required keyword argument" do
        let(:kwargs) { { b: "b" } }

        it "raises ArgumentError" do
          _(-> {
            subject.call(object, method_name:, kwargs:)
          }).must_raise(ArgumentError)
        end
      end
    end

    given "an Object with all required keyword Arguments" do
      let(:object) { AllRequiredKeywordArgumentsTestObject.new }
      let(:method_name) { :example_method }

      given "no keyword arguments" do
        let(:kwargs) { {} }

        it "raises ArgumentError" do
          _(-> {
            subject.call(object, method_name:, kwargs:)
          }).must_raise(ArgumentError)
        end
      end
    end
  end

  class SimpleTestObject
    def example_method = "a"

    private

    def example_private_method = "b"
  end

  class AllOptionalKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a: 1, b: 2) = [a, b]
  end

  class SomeOptionalKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a:, b: 2) = [a, b]
  end

  class AllRequiredKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a:, b:) = [a, b]
  end
end
