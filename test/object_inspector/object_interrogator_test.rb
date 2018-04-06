require "test_helper"

class ObjectInspector::ObjectInterrogatorTest < Minitest::Spec
  class SimpleTestObject
    def example_method; "a"; end
    private def example_private_method; "b"; end
  end

  class AllOptionalKeywordArgumentsTestObject
    def example_method(a: 1, b: 2); [a, b]; end
  end

  class SomeOptionalKeywordArgumentsTestObject
    def example_method(a:, b: 2); [a, b]; end
  end

  class AllRequiredKeywordArgumentsTestObject
    def example_method(a:, b:); [a, b]; end
  end

  describe ObjectInspector::ObjectInterrogator do
    let(:klazz) { ObjectInspector::ObjectInterrogator }

    describe "#call" do
      context "GIVEN an Object with no keyword Arguments" do
        subject {
          klazz.new(
            object: SimpleTestObject.new,
            method_name: method_name)
        }

        context "GIVEN a public method_name" do
          let(:method_name) { :example_method }

          it "returns the expected result" do
            subject.call.must_equal "a"
          end
        end

        context "GIVEN a private method_name" do
          let(:method_name) { :example_private_method }

          it "returns the expected result" do
            subject.call.must_equal "b"
          end
        end

        context "GIVEN an invalid method_name" do
          let(:method_name) { :invalid_method }

          it "returns nil" do
            subject.call.must_be_nil
          end
        end
      end

      context "GIVEN an Object with all optional keyword Arguments" do
        subject {
          klazz.new(
            object: AllOptionalKeywordArgumentsTestObject.new,
            method_name: :example_method,
            kargs: kargs)
        }

        context "GIVEN a valid keyword argument" do
          let(:kargs) { { a: "a" } }

          it "returns the expected result" do
            subject.call.must_equal ["a", 2]
          end
        end

        context "GIVEN an invalid keyword argument" do
          let(:kargs) { { invalid_karg: 1 } }

          it "returns the expected result" do
            subject.call.must_equal [1, 2]
          end
        end

        context "GIVEN no keyword arguments" do
          let(:kargs) { {} }

          it "returns the expected result" do
            subject.call.must_equal [1, 2]
          end
        end
      end

      context "GIVEN an Object with some optional keyword Arguments" do
        subject {
          klazz.new(
            object: SomeOptionalKeywordArgumentsTestObject.new,
            method_name: :example_method,
            kargs: kargs)
        }

        context "GIVEN a missing required keyword argument" do
          let(:kargs) { { b: "b" } }

          it "raises ArgumentError" do
            -> { subject.call }.must_raise ArgumentError
          end
        end
      end

      context "GIVEN an Object with all required keyword Arguments" do
        subject {
          klazz.new(
            object: AllRequiredKeywordArgumentsTestObject.new,
            method_name: :example_method,
            kargs: kargs)
        }

        context "GIVEN no keyword arguments" do
          let(:kargs) { {} }

          it "raises ArgumentError" do
            -> { subject.call }.must_raise ArgumentError
          end
        end
      end
    end
  end
end
