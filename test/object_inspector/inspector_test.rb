require "test_helper"

class ObjectInspector::InspectorTest < Minitest::Spec
  class FullTestObject
    def inspect_identification
      "Identification[id:1]"
    end

    def inspect_flags(scope: :self)
      scope == :self ? "FLAG1" : "FLAG1 | FLAG2"
    end

    def inspect_info(scope: :self)
      scope == :self ? "Info: 1" : "Info: 1 | Info: 2"
    end

    def inspect_name(scope: :self)
      scope == :self ? "Name: 1" : "Name: 1 | Name: 2"
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
    def my_method1
      "Result1"
    end
  end

  class WrapperForFullTestObject
    def to_model
      @to_model ||= FullTestObject.new
    end
  end

  describe ObjectInspector::Inspector do
    let(:klazz) { ObjectInspector::Inspector }

    let(:full_object1) { FullTestObject.new }
    let(:inspect_name_object1) { InspectNameTestObject.new }
    let(:display_name_object1) { DisplayNameTestObject.new }
    let(:inspect_and_display_name_object1) {
      InspectAndDisplayNameTestObject.new
    }
    let(:simple_object1) { SimpleTestObject.new }
    let(:wrapper_for_full_test_object1) { WrapperForFullTestObject.new }

    describe ".inspect" do
      subject { klazz }

      it "returns a String in the expected format" do
        result = subject.inspect(simple_object1)
        result.must_be_kind_of String
        result.must_equal "<ObjectInspector::InspectorTest::SimpleTestObject>"
      end
    end

    describe "#to_s" do
      context "GIVEN the default #scope (:self)" do
        subject { klazz.new(full_object1) }

        it "returns a String in the expected format for the Object" do
          result = subject.to_s
          result.must_be_kind_of String
          result.must_equal(
            "<Identification[id:1](FLAG1) Info: 1 :: Name: 1>")
        end
      end

      context "GIVEN a non-default #scope" do
        subject { klazz.new(full_object1, scope: :all) }

        it "returns a String in the expected format for the Object" do
          result = subject.to_s
          result.must_be_kind_of String
          result.must_equal(
            "<Identification[id:1](FLAG1 | FLAG2) Info: 1 | Info: 2 :: Name: 1 | Name: 2>")
        end
      end
    end

    describe "#identification" do
      context "GIVEN Object#inspect_identification is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_identification" do
          subject.identification.must_equal full_object1.inspect_identification
        end
      end

      context "GIVEN Object#inspect_identification isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns the Object's Class Name" do
          subject.identification.must_equal SimpleTestObject.name
        end
      end
    end

    describe "#flags" do
      context "GIVEN Object#inspect_flags is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_flags" do
          subject.flags.must_equal full_object1.inspect_flags
        end
      end

      context "GIVEN Object#inspect_flags isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          subject.flags.must_be_nil
        end
      end
    end

    describe "#info" do
      context "GIVEN Object#inspect_info is defined" do
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_info" do
          subject.info.must_equal full_object1.inspect_info
        end
      end

      context "GIVEN Object#inspect_info isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          subject.info.must_be_nil
        end
      end
    end

    describe "#name" do
      context "GIVEN Object#inspect_name is defined" do
        subject { klazz.new(inspect_name_object1) }

        it "returns Object#inspect_name" do
          subject.name.must_equal "INSPECT_NAME"
        end

        context "GIVEN Object#display_name is defined" do
          subject { klazz.new(inspect_and_display_name_object1) }

          it "returns Object#inspect_name" do
            subject.name.must_equal "INSPECT_NAME"
          end
        end
      end

      context "GIVEN Object#inspect_name isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          subject.name.must_be_nil
        end

        context "GIVEN Object#display_name is defined" do
          subject { klazz.new(display_name_object1) }

          it "returns Object#display_name" do
            subject.name.must_equal "DISPLAY_NAME"
          end
        end
      end
    end

    describe "#wrapped_object_inspection" do
      context "GIVEN #object_is_a_wrapper? is true" do
        subject { klazz.new(wrapper_for_full_test_object1) }

        it "returns Object#to_model#inspect" do
          subject.wrapped_object_inspection.
            must_equal "<Identification[id:1](FLAG1) Info: 1 :: Name: 1>"
        end
      end

      context "GIVEN #object_is_a_wrapper? is false" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          subject.wrapped_object_inspection.must_be_nil
        end
      end
    end

    describe "#evaluate_passed_in_value" do
      subject { klazz.new(simple_object1) }

      context "GIVEN #value is a Symbol" do
        it "returns Object#<value>, GIVEN Object responds to #value" do
          subject.send(:evaluate_passed_in_value, :my_method1).
            must_equal "Result1"
        end

        it "returns #value, GIVEN Object does not respond to #value" do
          subject.send(:evaluate_passed_in_value, :unknown_method1).
            must_equal :unknown_method1
        end
      end

      context "GIVEN #value is not a Symbol" do
        it "returns #value" do
          subject.send(:evaluate_passed_in_value, "my_method1").
            must_equal "my_method1"
        end
      end
    end
  end
end
