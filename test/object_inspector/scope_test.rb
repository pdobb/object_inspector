require "test_helper"

class ObjectInspector::ScopeTest < Minitest::Spec
  class SimpleTestObject
  end

  describe ObjectInspector::Scope do
    let(:klazz) { ObjectInspector::Scope }

    let(:self_scope) { klazz.new(:self) }
    let(:verbose_scope) { klazz.new(:verbose) }

    describe "#<method_name>?" do
      context "GIVEN method_name matches Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.self?.must_equal true
        end
      end

      context "GIVEN method_name does not match Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.verbose?.must_equal false
        end
      end
    end

    describe "#respond_to?" do
      context "GIVEN method_name matches Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.respond_to?(:self?).must_equal true
        end
      end

      context "GIVEN method_name does not match Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.verbose?.must_equal false
        end
      end
    end

    describe "#join_flags" do
      subject { self_scope }

      it "joins the passed in Array with the expected separator" do
        subject.join_flags(%w[1 2 3]).must_equal("1 / 2 / 3")
      end
    end

    describe "#join_info" do
      subject { self_scope }

      it "joins the passed in Array with the expected separator" do
        subject.join_info(%w[1 2 3]).must_equal("1 | 2 | 3")
      end
    end
  end
end
