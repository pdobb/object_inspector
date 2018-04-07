require "test_helper"

class ObjectInspector::DefaultFormatterTest < Minitest::Spec
  describe ObjectInspector::DefaultFormatter do
    let(:klazz) { ObjectInspector::DefaultFormatter }

    let(:inspector0) { OpenStruct.new }
    let(:inspector1) {
      OpenStruct.new(
        identification: "IDENTIFICATION",
        flags: "FLAGS",
        info: "INFO",
        name: "NAME")
    }

    describe "#call" do
      subject { klazz.new(inspector1) }

      it "returns a String surrounded by triangle brackets" do
        result = subject.call

        result.must_be_kind_of String
        result[0].must_equal "<"
        result[-1].must_equal ">"
      end
    end

    describe "#build_identification_string" do
      subject { klazz.new(inspector0)}

      it "returns a String with the expected format" do
        subject.send(:build_identification_string, "IDENTIFICATION").
          must_equal "IDENTIFICATION"
      end
    end

    describe "#build_flags_string" do
      subject { klazz.new(inspector0)}

      it "returns a String with the expected format" do
        subject.send(:build_flags_string, "FLAGS").must_equal "[FLAGS]"
      end

      it "up-cases lowercased flags" do
        subject.send(:build_flags_string, "flags").must_include "FLAGS"
      end

      it "returns nil, GIVEN #flags == nil" do
        subject.send(:build_flags_string, nil).must_be_nil
      end
    end

    describe "#build_info_string" do
      subject { klazz.new(inspector0)}

      it "returns a String with the expected format" do
        subject.send(:build_info_string, "INFO").must_equal " (INFO)"
      end

      it "returns nil, GIVEN #flags == nil" do
        subject.send(:build_info_string, nil).must_be_nil
      end
    end

    describe "#build_name_string" do
      subject { klazz.new(inspector0)}

      it "returns a String with the expected format" do
        subject.send(:build_name_string, "NAME").must_equal " :: NAME"
      end

      it "returns nil, GIVEN #flags == nil" do
        subject.send(:build_name_string, nil).must_be_nil
      end
    end
  end
end
