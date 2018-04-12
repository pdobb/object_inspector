require "test_helper"

class ObjectInspector::TemplatingFormatterTest < Minitest::Spec
  describe ObjectInspector::TemplatingFormatter do
    let(:klazz) { ObjectInspector::TemplatingFormatter }

    let(:inspector_with_flags_and_info_and_name) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_flags_and_info) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        info: "INFO")
    }
    let(:inspector_with_flags_and_name) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2",
        name: "NAME")
    }
    let(:inspector_with_info_and_name) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        info: "INFO",
        name: "NAME")
    }
    let(:inspector_with_name) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        name: "NAME")
    }
    let(:inspector_with_flags) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        flags: "FLAG1 | FLAG2")
    }
    let(:inspector_with_info) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        info: "INFO")
    }
    let(:inspector_with_base) {
      OpenStruct.new(
        identification: "IDENTIFICATION")
    }

    describe "#call" do
      context "GIVEN an Inspector with #flags and #info and #name" do
        subject { klazz.new(inspector_with_flags_and_info_and_name)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION(FLAG1 | FLAG2) INFO :: NAME>"
        end
      end

      context "GIVEN an Inspector with #flags and #info" do
        subject { klazz.new(inspector_with_flags_and_info)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION(FLAG1 | FLAG2) INFO>"
        end
      end

      context "GIVEN an Inspector with #flags and #name" do
        subject { klazz.new(inspector_with_flags_and_name)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION(FLAG1 | FLAG2) :: NAME>"
        end
      end

      context "GIVEN an Inspector with #info and #name" do
        subject { klazz.new(inspector_with_info_and_name)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION INFO :: NAME>"
        end
      end

      context "GIVEN an Inspector with #name" do
        subject { klazz.new(inspector_with_name)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION :: NAME>"
        end
      end

      context "GIVEN an Inspector with #flags" do
        subject { klazz.new(inspector_with_flags)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION(FLAG1 | FLAG2)>"
        end
      end

      context "GIVEN an Inspector with #info" do
        subject { klazz.new(inspector_with_info)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION INFO>"
        end
      end

      context "GIVEN an Inspector with #base" do
        subject { klazz.new(inspector_with_base)}

        it "returns the expected String" do
          subject.call.must_equal "<IDENTIFICATION>"
        end
      end
    end
  end
end
