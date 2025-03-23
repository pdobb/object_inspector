# frozen_string_literal: true

require "test_helper"

class ObjectInspector::CombiningFormatterTest < Minitest::Spec
  class SimpleTestObject
    def inspect_identification; "SIMPLE_TEST_OBJECT" end
  end

  InspectableTestClass =
    Struct.new(
      :identification,
      :flags,
      :issues,
      :info,
      :name,
      :wrapped_object_inspection_result,
      keyword_init: true) do
      # :reek:LongParameterList
      def initialize(
            identification: nil,
            flags: nil,
            issues: nil,
            info: nil,
            name: nil,
            wrapped_object_inspection_result: nil)
        super
      end
    end

  describe "ObjectInspector::CombiningFormatter" do
    let(:klazz) { ObjectInspector::CombiningFormatter }
    let(:inspector_klazz) { ObjectInspector::Inspector }

    let(:inspector_with_wrapped_object) {
      InspectableTestClass.new(
        identification: "WRAPPER",
        wrapped_object_inspection_result:
          inspector_klazz.new(SimpleTestObject.new))
    }
    let(:inspector_with_flags_and_issues_and_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        issues: "ISSUE1 | ISSUE2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_flags_and_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_flags_and_info) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        info: "INFO")
    }
    let(:inspector_with_flags_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        name: "NAME")
    }
    let(:inspector_with_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        name: "NAME")
    }
    let(:inspector_with_flags) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2")
    }
    let(:inspector_with_info) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        info: "INFO")
    }
    let(:inspector_with_base) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION")
    }

    describe "#call" do
      context "GIVEN an Inspector with a wrapped object" do
        subject { klazz.new(inspector_with_wrapped_object) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<WRAPPER> "\
            "#{ObjectInspector.configuration.presented_object_separator} "\
            "<SIMPLE_TEST_OBJECT>")
        end
      end

      context "GIVEN an Inspector with #flags and #info and #name" do
        subject { klazz.new(inspector_with_flags_and_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) INFO :: NAME>")
        end
      end

      context "GIVEN an Inspector with #flags #issues and #info and #name" do
        subject { klazz.new(inspector_with_flags_and_issues_and_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>")
        end
      end

      context "GIVEN an Inspector with #flags and #info" do
        subject { klazz.new(inspector_with_flags_and_info) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) INFO>")
        end
      end

      context "GIVEN an Inspector with #flags and #name" do
        subject { klazz.new(inspector_with_flags_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) :: NAME>")
        end
      end

      context "GIVEN an Inspector with #info and #name" do
        subject { klazz.new(inspector_with_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION INFO :: NAME>")
        end
      end

      context "GIVEN an Inspector with #name" do
        subject { klazz.new(inspector_with_name) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION :: NAME>")
        end
      end

      context "GIVEN an Inspector with #flags" do
        subject { klazz.new(inspector_with_flags) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION(FLAG1 | FLAG2)>")
        end
      end

      context "GIVEN an Inspector with #info" do
        subject { klazz.new(inspector_with_info) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION INFO>")
        end
      end

      context "GIVEN an Inspector with #base" do
        subject { klazz.new(inspector_with_base) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION>")
        end
      end
    end
  end
end
