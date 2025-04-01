# frozen_string_literal: true

require "test_helper"

class ObjectInspector::InspectorsHelperTest < Minitest::Spec
  describe "ObjectInspector::InspectorsHelper" do
    let(:simple_object1) { SimpleTestObject.new }

    let(:delegating_wrapper_for_full_object1) {
      DelegatingWrapperForFullTestObject.new(full_object1)
    }
    let(:full_object1) { FullTestObject.new }

    describe "#inspect" do
      subject { simple_object1 }

      describe "GIVEN a simple object" do
        it "calls ObjectInspector::Inspector from Object#inspect" do
          _(subject.inspect).must_equal(
            "<ObjectInspector::InspectorsHelperTest::SimpleTestObject>")
        end
      end

      context "GIVEN a full object" do
        subject { full_object1 }

        it "returns a String in the expected format for the Object" do
          _(subject.inspect).must_equal(
            "<Identification[id:9](FLAG1) Info: 1 :: Name: 1>")
        end
      end

      context "GIVEN a delegating wrapper object" do
        subject { delegating_wrapper_for_full_object1 }

        it "returns a String in the expected format for the Object" do
          # rubocop:disable Layout/LineLength
          _(subject.inspect).must_equal(
            "<ObjectInspector::InspectorsHelperTest::DelegatingWrapperForFullTestObject>  ⇨  "\
            "<Identification[id:9](FLAG1) Info: 1 :: Name: 1>")
          # rubocop:enable Layout/LineLength
        end
      end
    end

    describe "#inspect!" do
      subject { simple_object1 }

      describe "GIVEN a simple object" do
        it "returns the expected String" do
          _(subject.inspect!).must_equal(
            "<ObjectInspector::InspectorsHelperTest::SimpleTestObject>")
        end
      end

      context "GIVEN a full object" do
        subject { full_object1 }

        it "returns a String in the expected format for the Object" do
          _(subject.inspect!).must_equal(
            "<Identification[id:9](FLAG1 | FLAG2 | FLAG3) "\
            "Info: 1 | Info: 2 | Info: 3 :: Name: 1 | Name: 2 | Name: 3>")
        end
      end

      context "GIVEN a delegating wrapper object" do
        subject { delegating_wrapper_for_full_object1 }

        it "returns a String in the expected format for the Object" do
          # rubocop:disable Layout/LineLength
          _(subject.inspect!).must_equal(
            "<ObjectInspector::InspectorsHelperTest::DelegatingWrapperForFullTestObject>  ⇨  "\
            "<Identification[id:9](FLAG1 | FLAG2 | FLAG3) "\
            "Info: 1 | Info: 2 | Info: 3 :: Name: 1 | Name: 2 | Name: 3>")
          # rubocop:enable Layout/LineLength
        end
      end
    end
  end

  class SimpleTestObject
    include ObjectInspector::InspectorsHelper
  end

  # :reek:RepeatedConditional
  class FullTestObject
    include ObjectInspector::InspectorsHelper

    private

    def inspect_identification = "Identification[id:9]"

    def inspect_flags(scope: ObjectInspector::Scope.new)
      [
        ("FLAG1" if scope.self?),
        ("FLAG2" if scope.complex?),
        ("FLAG3" if scope.verbose?),
      ].tap(&:compact!).join(" | ")
    end

    def inspect_info(scope: ObjectInspector::Scope.new)
      [
        ("Info: 1" if scope.self?),
        ("Info: 2" if scope.complex?),
        ("Info: 3" if scope.verbose?),
      ].tap(&:compact!).join(" | ")
    end

    def inspect_name(scope: ObjectInspector::Scope.new)
      [
        ("Name: 1" if scope.self?),
        ("Name: 2" if scope.complex?),
        ("Name: 3" if scope.verbose?),
      ].tap(&:compact!).join(" | ")
    end
  end

  class DelegatingWrapperForFullTestObject
    include ObjectInspector::InspectorsHelper

    def initialize(object)
      @object = object
    end

    def inspect_identification = self.class.name
    def inspect_flags(*) = nil
    def inspect_info(*) = nil
    def inspect_issues(*) = nil
    def inspect_name(*) = nil

    def to_model = @object

    private

    def method_missing(method_symbol, *)
      @object.__send__(method_symbol, *)
    end

    # :reek:ManualDispatch
    def respond_to_missing?(*)
      @object.respond_to?(*) || super
    end
  end
end
