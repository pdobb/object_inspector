# frozen_string_literal: true

require "test_helper"

class ObjectInspector::TemplatingFormatterTest < Minitest::Spec
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

  describe "ObjectInspector::TemplatingFormatter" do
    let(:unit_class) { ObjectInspector::TemplatingFormatter }
    let(:inspector_unit_class) { ObjectInspector::Inspector }

    let(:inspector_with_wrapped_object) {
      InspectableTestClass.new(
        identification: "WRAPPER",
        wrapped_object_inspection_result:
          inspector_unit_class.new(SimpleTestObject.new))
    }
    let(:inspector_with_flags_and_issues_and_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        issues: "ISSUE1 | ISSUE2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_flags_and_issues_and_info) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        issues: "ISSUE1 | ISSUE2",
        info: "INFO")
    }
    let(:inspector_with_flags_and_issues_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        issues: "ISSUE1 | ISSUE2",
        name: "NAME")
    }
    let(:inspector_with_flags_and_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_issues_and_info_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        issues: "ISSUE1 | ISSUE2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_flags_and_issues) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        issues: "ISSUE1 | ISSUE2")
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
    let(:inspector_with_issues_and_name) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        issues: "ISSUE1 | ISSUE2",
        name: "NAME")
    }
    let(:inspector_with_issues_and_info) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        issues: "ISSUE1 | ISSUE2",
        info: "INFO")
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
    let(:inspector_with_issues) {
      InspectableTestClass.new(
        identification: "IDENTIFICATION",
        issues: "ISSUE1 | ISSUE2")
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
      given "an Inspector with a wrapped object" do
        subject { unit_class.new(inspector_with_wrapped_object) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<WRAPPER> "\
            "#{ObjectInspector.configuration.presented_object_separator} "\
            "<SIMPLE_TEST_OBJECT>")
        end
      end

      given "an Inspector with #flags, #issues, #info and #name" do
        subject {
          unit_class.new(inspector_with_flags_and_issues_and_info_and_name)
        }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>")
        end
      end

      given "an Inspector with #flags and #issues and #info" do
        subject { unit_class.new(inspector_with_flags_and_issues_and_info) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) !!ISSUE1 | ISSUE2!! INFO>")
        end
      end

      given "an Inspector with #flags and #issues and #name" do
        subject { unit_class.new(inspector_with_flags_and_issues_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) !!ISSUE1 | ISSUE2!! :: NAME>")
        end
      end

      given "an Inspector with #flags and #info and #name" do
        subject { unit_class.new(inspector_with_flags_and_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) INFO :: NAME>")
        end
      end

      given "an Inspector with #issues and #info and #name" do
        subject { unit_class.new(inspector_with_issues_and_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION !!ISSUE1 | ISSUE2!! INFO :: NAME>")
        end
      end

      given "an Inspector with flags and #issues" do
        subject { unit_class.new(inspector_with_flags_and_issues) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) !!ISSUE1 | ISSUE2!!>")
        end
      end

      given "an Inspector with #flags and #info" do
        subject { unit_class.new(inspector_with_flags_and_info) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) INFO>")
        end
      end

      given "an Inspector with #flags and #name" do
        subject { unit_class.new(inspector_with_flags_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION(FLAG1 | FLAG2) :: NAME>")
        end
      end

      given "an Inspector with #info and #name" do
        subject { unit_class.new(inspector_with_info_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION INFO :: NAME>")
        end
      end

      given "an Inspector with #issues and #info" do
        subject { unit_class.new(inspector_with_issues_and_info) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION !!ISSUE1 | ISSUE2!! INFO>")
        end
      end

      given "an Inspector with #issues and #name" do
        subject { unit_class.new(inspector_with_issues_and_name) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION !!ISSUE1 | ISSUE2!! :: NAME>")
        end
      end

      given "an Inspector with #name" do
        subject { unit_class.new(inspector_with_name) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION :: NAME>")
        end
      end

      given "an Inspector with #flags" do
        subject { unit_class.new(inspector_with_flags) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION(FLAG1 | FLAG2)>")
        end
      end

      given "an Inspector with #issues" do
        subject { unit_class.new(inspector_with_issues) }

        it "returns the expected String" do
          _(subject.call).must_equal(
            "<IDENTIFICATION !!ISSUE1 | ISSUE2!!>")
        end
      end

      given "an Inspector with #info" do
        subject { unit_class.new(inspector_with_info) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION INFO>")
        end
      end

      given "an Inspector with #base" do
        subject { unit_class.new(inspector_with_base) }

        it "returns the expected String" do
          _(subject.call).must_equal("<IDENTIFICATION>")
        end
      end
    end
  end
end
