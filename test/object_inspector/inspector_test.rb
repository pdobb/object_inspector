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

  class SimpleTestObject
  end

  describe ObjectInspector::Inspector do
    let(:klazz) { ObjectInspector::Inspector }

    let(:full_object1) { FullTestObject.new }
    let(:simple_object1) { SimpleTestObject.new }

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
            "<Identification[id:1][FLAG1] (Info: 1) :: Name: 1>")
        end
      end

      context "GIVEN a non-default #scope" do
        subject { klazz.new(full_object1, scope: :all) }

        it "returns a String in the expected format for the Object" do
          result = subject.to_s
          result.must_be_kind_of String
          result.must_equal(
            "<Identification[id:1][FLAG1 | FLAG2] (Info: 1 | Info: 2) :: Name: 1 | Name: 2>")
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
        subject { klazz.new(full_object1) }

        it "returns Object#inspect_name" do
          subject.name.must_equal full_object1.inspect_name
        end
      end

      context "GIVEN Object#inspect_name isn't defined" do
        subject { klazz.new(simple_object1) }

        it "returns nil" do
          subject.name.must_be_nil
        end
      end
    end
  end
end
