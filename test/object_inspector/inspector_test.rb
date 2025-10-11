# frozen_string_literal: true

require "test_helper"

class ObjectInspector::InspectorTest < Minitest::Spec
  let(:unit_class) { ObjectInspector::Inspector }

  let(:wrapper_for_full_test_object1) { WrapperForFullTestObject.new }

  let(:full_object1) { FullTestObject.new }
  let(:inspect_name_object1) { InspectNameTestObject.new }
  let(:display_name_object1) { DisplayNameTestObject.new }
  let(:inspect_and_display_name_object1) {
    InspectAndDisplayNameTestObject.new
  }
  let(:simple_object1) { SimpleTestObject.new }

  describe ".inspect" do
    subject { unit_class }

    it "returns a String in the expected format" do
      result = subject.inspect(simple_object1)

      _(result).must_equal(
        "<ObjectInspector::InspectorTest::SimpleTestObject>",
      )
    end
  end

  describe "#to_s" do
    given "the default #scope (:self)" do
      subject { unit_class.new(full_object1) }

      it "returns a String in the expected format for the Object" do
        _(subject.to_s).must_equal(
          "<Identification[id:1](FLAG1) Info: 1 :: Name: 1>",
        )
      end
    end

    given "a non-default #scope" do
      subject { unit_class.new(full_object1, scope: :verbose) }

      it "returns a String in the expected format for the Object" do
        _(subject.to_s).must_equal(
          "<Identification[id:1](FLAG1 | FLAG2) "\
          "Info: 1 | Info: 2 :: Name: 1 | Name: 2>",
        )
      end
    end
  end

  describe "#identification" do
    given "Object#inspect_identification is defined" do
      subject { unit_class.new(full_object1) }

      it "returns Object#inspect_identification" do
        _(subject.identification).must_equal(
          full_object1.inspect_identification,
        )
      end
    end

    given "Object#inspect_identification isn't defined" do
      subject { unit_class.new(simple_object1) }

      it "returns the Object's Class Name" do
        _(subject.identification).must_equal(SimpleTestObject.name)
      end
    end

    given ":identification is passed in" do
      subject {
        unit_class.new(
          simple_object1,
          identification: "PASSED_IN_IDENTIFICATION",
        )
      }

      it "returns the passed in :identification" do
        _(subject.identification).must_equal("PASSED_IN_IDENTIFICATION")
      end
    end
  end

  describe "#flags" do
    given "Object#inspect_flags is defined" do
      subject { unit_class.new(full_object1) }

      it "returns Object#inspect_flags" do
        _(subject.flags).must_equal(full_object1.inspect_flags)
      end
    end

    given "Object#inspect_flags isn't defined" do
      subject { unit_class.new(simple_object1) }

      it "returns nil" do
        _(subject.flags).must_be_nil
      end
    end

    given ":flags is passed in" do
      subject { unit_class.new(simple_object1, flags: "PASSED_IN_FLAG") }

      it "returns the passed in :flags" do
        _(subject.flags).must_equal("PASSED_IN_FLAG")
      end
    end
  end

  describe "#info" do
    given "Object#inspect_info is defined" do
      subject { unit_class.new(full_object1) }

      it "returns Object#inspect_info" do
        _(subject.info).must_equal(full_object1.inspect_info)
      end
    end

    given "Object#inspect_info isn't defined" do
      subject { unit_class.new(simple_object1) }

      it "returns nil" do
        _(subject.info).must_be_nil
      end
    end

    given ":info is passed in" do
      subject { unit_class.new(simple_object1, info: "PASSED_IN_INFO") }

      it "returns the passed in :info" do
        _(subject.info).must_equal("PASSED_IN_INFO")
      end
    end
  end

  describe "#name" do
    given "Object#inspect_name is defined" do
      subject { unit_class.new(inspect_name_object1) }

      it "returns Object#inspect_name" do
        _(subject.name).must_equal("INSPECT_NAME")
      end

      given "Object#display_name is defined" do
        subject { unit_class.new(inspect_and_display_name_object1) }

        it "returns Object#inspect_name" do
          _(subject.name).must_equal("INSPECT_NAME")
        end
      end

      given ":name is passed in" do
        subject {
          unit_class.new(inspect_name_object1, name: "PASSED_IN_NAME")
        }

        it "returns the passed in :name" do
          _(subject.name).must_equal("PASSED_IN_NAME")
        end
      end
    end

    given "Object#inspect_name isn't defined" do
      subject { unit_class.new(simple_object1) }

      it "returns nil" do
        _(subject.name).must_be_nil
      end

      given "Object#display_name is defined" do
        subject { unit_class.new(display_name_object1) }

        it "returns Object#display_name" do
          _(subject.name).must_equal("DISPLAY_NAME")
        end
      end
    end
  end

  describe "#wrapped_object_inspection_result" do
    given "#object_is_a_wrapper? is true" do
      subject { unit_class.new(wrapper_for_full_test_object1) }

      it "returns Object#to_model#inspect" do
        _(subject.wrapped_object_inspection_result)
          .must_equal("<Identification[id:1](FLAG1) Info: 1 :: Name: 1>")
      end
    end

    given "#object_is_a_wrapper? is false" do
      subject { unit_class.new(simple_object1) }

      it "returns nil" do
        _(subject.wrapped_object_inspection_result).must_be_nil
      end
    end
  end

  describe "#evaluate_passed_in_value" do
    subject { unit_class.new(simple_object1) }

    given "#value is a Symbol" do
      it "returns Object#<value>, GIVEN Object responds to #value" do
        _(
          subject.__send__(:evaluate_passed_in_value, :simple_test_method),
        )
          .must_equal("TEST_RESULT")
      end

      it "returns #value, GIVEN Object does not respond to #value" do
        _(subject.__send__(:evaluate_passed_in_value, :unknown_method1))
          .must_equal(:unknown_method1)
      end
    end

    given "#value is not a Symbol" do
      it "returns #value" do
        _(
          subject.__send__(:evaluate_passed_in_value, "simple_test_method"),
        )
          .must_equal("simple_test_method")
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
    def inspect_name = "INSPECT_NAME"
  end

  class DisplayNameTestObject
    def display_name = "DISPLAY_NAME"
  end

  class InspectAndDisplayNameTestObject
    def inspect_name = "INSPECT_NAME"

    def display_name = "DISPLAY_NAME"
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
