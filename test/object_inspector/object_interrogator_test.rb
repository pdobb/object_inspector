# frozen_string_literal: true

require "test_helper"

class ObjectInspector::ObjectInterrogatorTest < Minitest::Spec
  let(:unit_class) { ObjectInspector::ObjectInterrogator }

  describe "#call" do
    given "an Object with no keyword Arguments" do
      subject {
        unit_class.new(
          object: SimpleTestObject.new,
          method_name: method_name)
      }

      given "a public method_name" do
        let(:method_name) { :example_method }

        it "returns the expected result" do
          _(subject.call).must_equal("a")
        end
      end

      given "a private method_name" do
        let(:method_name) { :example_private_method }

        it "returns the expected result" do
          _(subject.call).must_equal("b")
        end
      end

      given "an invalid method_name" do
        let(:method_name) { :invalid_method }

        it "returns nil" do
          _(subject.call).must_be_nil
        end
      end
    end

    given "an Object with all optional keyword Arguments" do
      subject {
        unit_class.new(
          object: AllOptionalKeywordArgumentsTestObject.new,
          method_name: :example_method,
          kwargs: kwargs)
      }

      given "a valid keyword argument" do
        let(:kwargs) { { a: "a" } }

        it "returns the expected result" do
          _(subject.call).must_equal(["a", 2])
        end
      end

      given "an invalid keyword argument" do
        let(:kwargs) { { invalid_kwarg: 1 } }

        it "returns the expected result" do
          _(subject.call).must_equal([1, 2])
        end
      end

      given "no keyword arguments" do
        let(:kwargs) { {} }

        it "returns the expected result" do
          _(subject.call).must_equal([1, 2])
        end
      end
    end

    given "an Object with some optional keyword Arguments" do
      subject {
        unit_class.new(
          object: SomeOptionalKeywordArgumentsTestObject.new,
          method_name: :example_method,
          kwargs: kwargs)
      }

      given "a missing required keyword argument" do
        let(:kwargs) { { b: "b" } }

        it "raises ArgumentError" do
          _(-> { subject.call }).must_raise(ArgumentError)
        end
      end
    end

    given "an Object with all required keyword Arguments" do
      subject {
        unit_class.new(
          object: AllRequiredKeywordArgumentsTestObject.new,
          method_name: :example_method,
          kwargs: kwargs)
      }

      given "no keyword arguments" do
        let(:kwargs) { {} }

        it "raises ArgumentError" do
          _(-> { subject.call }).must_raise(ArgumentError)
        end
      end
    end
  end

  class SimpleTestObject
    def example_method; "a"; end

    private

    def example_private_method; "b"; end
  end

  class AllOptionalKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a: 1, b: 2); [a, b]; end
  end

  class SomeOptionalKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a:, b: 2); [a, b]; end
  end

  class AllRequiredKeywordArgumentsTestObject
    # :reek:UncommunicativeParameterName
    def example_method(a:, b:); [a, b]; end
  end
end
