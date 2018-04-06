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
    let(:inspector2) {
      OpenStruct.new(
        identification: "identification",
        flags: "flags",
        info: "info",
        name: "name")
    }

    describe "#call" do
      subject { klazz.new(inspector0) }

      it "returns a String surrounded by triangle brackets" do
        result = subject.call

        result.must_be_kind_of String
        result[0].must_equal "<"
        result[-1].must_equal ">"
      end
    end

    describe "#build_identification_string" do
      subject { klazz.new(inspector1)}

      it "returns a String with the expected format" do
        subject.send(:build_identification_string).must_equal "IDENTIFICATION"
      end
    end

    describe "#build_flags_string" do
      context "GIVEN #flags != nil" do
        subject { klazz.new(inspector1)}

        it "returns a String with the expected format" do
          subject.send(:build_flags_string).must_equal "[FLAGS]"
        end

        context "GIVEN lowercased Strings" do
          subject { klazz.new(inspector2)}

          it "up-cases Inspector#flags" do
            subject.send(:build_flags_string).must_equal "[FLAGS]"
          end
        end
      end

      context "GIVEN #flags == nil" do
        subject { klazz.new(inspector0) }

        it "returns nil" do
          subject.send(:build_flags_string).must_be_nil
        end
      end
    end

    describe "#build_info_string" do
      context "GIVEN #info != nil" do
        subject { klazz.new(inspector1)}

        it "returns a String with the expected format" do
          subject.send(:build_info_string).must_equal " (INFO)"
        end

        context "GIVEN lowercased Strings" do
          subject { klazz.new(inspector2)}

          it "doesn't up-case Inspector#info" do
            subject.send(:build_info_string).must_equal " (info)"
          end
        end
      end

      context "GIVEN #info == nil" do
        subject { klazz.new(inspector0) }

        it "returns nil" do
          subject.send(:build_info_string).must_be_nil
        end
      end
    end

    describe "#build_name_string" do
      context "GIVEN #name != nil" do
        subject { klazz.new(inspector1)}

        it "returns a String with the expected format" do
          subject.send(:build_name_string).must_equal " :: NAME"
        end

        context "GIVEN lowercased Strings" do
          subject { klazz.new(inspector2)}

          it "doesn't up-case Inspector#name" do
            subject.send(:build_name_string).must_equal " :: name"
          end
        end
      end

      context "GIVEN #name == nil" do
        subject { klazz.new(inspector0) }

        it "returns nil" do
          subject.send(:build_name_string).must_be_nil
        end
      end
    end
  end
end
