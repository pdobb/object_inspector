# frozen_string_literal: true

require "test_helper"

class ObjectInspector::InspectorsHelperTest < Minitest::Spec
  describe "ObjectInspector::InspectorsHelper" do
    let(:delegating_wrapper_for_full_test_object1) {
      DelegatingWrapperForFullTestObject.new(full_object1)
    }

    let(:simple_object1) { SimpleTestObject.new }
    let(:full_object1) { FullTestObject.new }

    describe "#inspect" do
      subject { simple_object1 }

      it "calls ObjectInspector::Inspector from Object#inspect" do
        _(subject.inspect).must_equal(
          "<ObjectInspector::InspectorsHelperTest::SimpleTestObject>")
      end

      context "GIVEN a delegating wrapper object" do
        subject { delegating_wrapper_for_full_test_object1 }

        it "returns a String in the expected format for the Object" do
          # rubocop:disable Layout/LineLength
          _(subject.inspect).must_equal(
            "<ObjectInspector::InspectorsHelperTest::DelegatingWrapperForFullTestObject>  ⇨  "\
            "<Identification[id:1](FLAG1) Info: 1 :: Name: 1>")
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

  class DelegatingWrapperForFullTestObject
    include ObjectInspector::InspectorsHelper

    def initialize(full_test_object)
      @full_test_object = full_test_object
    end

    def inspect(**)
      super(
        identification: self.class.name,
        name: nil,
        flags: nil,
        info: nil,
        issues: nil,
        **)
    end

    def to_model
      @full_test_object
    end

    private

    def method_missing(method_symbol, ...)
      @full_test_object.__send__(method_symbol, ...)
    end

    # :reek:ManualDispatch
    def respond_to_missing?(...)
      @full_test_object.respond_to?(...) || super
    end
  end
end
