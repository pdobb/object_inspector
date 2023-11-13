# frozen_string_literal: true

require "test_helper"

class ObjectInspector::InspectorTest < Minitest::Spec
  describe "ObjectInspector::Inspector" do
    let(:klazz) { ObjectInspector::Inspector }

    let(:wrapper_for_full_test_object1) { WrapperForFullTestObject.new }

    let(:full_object1) { FullTestObject.new }
    let(:inspect_name_object1) { InspectNameTestObject.new }
    let(:display_name_object1) { DisplayNameTestObject.new }
    let(:inspect_and_display_name_object1) {
      InspectAndDisplayNameTestObject.new
    }
    let(:simple_object1) { SimpleTestObject.new }

    describe ".inspect" do
      subject { klazz }

      it "returns a String in the expected format" do
        result = subject.inspect(simple_object1)
        value(result).must_equal(
          "<ObjectInspector::InspectorTest::SimpleTestObject>")
      end
    end

    describe "#to_s" do
      context "GIVEN the default #scope (:self)" do
        subject { klazz.new(full_object1) }

        it "returns a String in the expected format for the Object" do
          value(subject.to_s).must_equal(
            "<Identification[id:1](FLAG1) Info: 1 :: Name: 1>")
        end
      end

      context "GIVEN a non-default #scope" do
        subject { klazz.new(full_object1, scope: :verbose) }

        it "returns a String in the expected format for the Object" do
          value(subject.to_s).must_equal(
            "<Identification[id:1](FLAG1 | FLAG2) "\
            "Info: 1 | Info: 2 :: Name: 1 | Name: 2>")
        end
      end
    end

    describe "#identification" do
      context "GIVEN Object#inspect_identification is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_identification" do
          value(subject.identification).must_equal(
            full_object1.inspect_identification)
        end
      end

      context "GIVEN Object#inspect_identification isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns the Object's Class Name" do
          value(subject.identification).must_equal(SimpleTestObject.name)
        end
      end

      context "GIVEN :identification is passed in" do
        subject {
          klazz.new(simple_object1,
                    identification: "PASSED_IN_IDENTIFICATION")
        }

        it "returns the passed in :identification" do
          value(subject.identification).must_equal("PASSED_IN_IDENTIFICATION")
        end
      end
    end

    describe "#flags" do
      context "GIVEN Object#inspect_flags is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_flags" do
          value(subject.flags).must_equal(full_object1.inspect_flags)
        end
      end

      context "GIVEN Object#inspect_flags isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          value(subject.flags).must_be_nil
        end
      end

      context "GIVEN :flags is passed in" do
        subject { klazz.new(simple_object1, flags: "PASSED_IN_FLAG") }

        it "returns the passed in :flags" do
          value(subject.flags).must_equal("PASSED_IN_FLAG")
        end
      end
    end

    describe "#info" do
      context "GIVEN Object#inspect_info is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_info" do
          value(subject.info).must_equal(full_object1.inspect_info)
        end
      end

      context "GIVEN Object#inspect_info isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          value(subject.info).must_be_nil
        end
      end

      context "GIVEN :info is passed in" do
        subject { klazz.new(simple_object1, info: "PASSED_IN_INFO") }

        it "returns the passed in :info" do
          value(subject.info).must_equal("PASSED_IN_INFO")
        end
      end
    end

    describe "#name" do
      context "GIVEN Object#inspect_name is defined" do
        subject { klazz.new(inspect_name_object1) }

        it "returns Object#inspect_name" do
          value(subject.name).must_equal("INSPECT_NAME")
        end

        context "GIVEN Object#display_name is defined" do
          subject { klazz.new(inspect_and_display_name_object1) }

          it "returns Object#inspect_name" do
            value(subject.name).must_equal("INSPECT_NAME")
          end
        end

        context "GIVEN :name is passed in" do
          subject { klazz.new(inspect_name_object1, name: "PASSED_IN_NAME") }

          it "returns the passed in :name" do
            value(subject.name).must_equal("PASSED_IN_NAME")
          end
        end
      end

      context "GIVEN Object#inspect_name isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          value(subject.name).must_be_nil
        end

        context "GIVEN Object#display_name is defined" do
          subject { klazz.new(display_name_object1) }

          it "returns Object#display_name" do
            value(subject.name).must_equal("DISPLAY_NAME")
          end
        end
      end
    end

    describe "#wrapped_object_inspection_result" do
      context "GIVEN #object_is_a_wrapper? is true" do
        subject { klazz.new(wrapper_for_full_test_object1) }

        it "returns Object#to_model#inspect" do
          value(subject.wrapped_object_inspection_result).
            must_equal("<Identification[id:1](FLAG1) Info: 1 :: Name: 1>")
        end
      end

      context "GIVEN #object_is_a_wrapper? is false" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          value(subject.wrapped_object_inspection_result).must_be_nil
        end
      end
    end

    describe "#evaluate_passed_in_value" do
      subject { klazz.new(simple_object1) }

      context "GIVEN #value is a Symbol" do
        it "returns Object#<value>, GIVEN Object responds to #value" do
          value(subject.send(:evaluate_passed_in_value, :simple_test_method)).
            must_equal("TEST_RESULT")
        end

        it "returns #value, GIVEN Object does not respond to #value" do
          value(subject.send(:evaluate_passed_in_value, :unknown_method1)).
            must_equal(:unknown_method1)
        end
      end

      context "GIVEN #value is not a Symbol" do
        it "returns #value" do
          value(subject.send(:evaluate_passed_in_value, "simple_test_method")).
            must_equal("simple_test_method")
        end
      end
    end
  end

  # :reek:RepeatedConditional
  class FullTestObject
    def inspect_identification
      "Identification[id:1]"
    end

    def inspect_flags(scope: ObjectInspector::Scope.new)
      scope.self? ? "FLAG1" : "FLAG1 | FLAG2"
    end

    def inspect_info(scope: ObjectInspector::Scope.new)
      scope.self? ? "Info: 1" : "Info: 1 | Info: 2"
    end

    def inspect_name(scope: ObjectInspector::Scope.new)
      scope.self? ? "Name: 1" : "Name: 1 | Name: 2"
    end
  end

  class InspectNameTestObject
    def inspect_name; "INSPECT_NAME" end
  end

  class DisplayNameTestObject
    def display_name; "DISPLAY_NAME" end
  end

  class InspectAndDisplayNameTestObject
    def inspect_name; "INSPECT_NAME" end

    def display_name; "DISPLAY_NAME" end
  end

  class SimpleTestObject
    def simple_test_method
      "TEST_RESULT"
    end
  end

  class WrapperForFullTestObject
    def to_model
      @to_model ||= FullTestObject.new
    end
  end
end
