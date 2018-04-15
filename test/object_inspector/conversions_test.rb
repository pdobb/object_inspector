require "test_helper"

class ObjectInspector::ConversionsTest < Minitest::Spec
  describe ObjectInspector::Conversions do
    let(:klazz) { ObjectInspector::Conversions }

    let(:scope1) { ObjectInspector::Scope.new }

    describe ".Scope" do
      subject { klazz }

      context "GIVEN an ObjectInspector::Scope" do
        it "returns the same ObjectInspector::Scope" do
          klazz.Scope(scope1).object_id.must_equal scope1.object_id
        end
      end

      context "GIVEN a Symbol" do
        it "returns a new Scope for the given Symbol" do
          new_scope = klazz.Scope(:verbose)
          new_scope.names.must_include "verbose"
        end
      end
    end
  end
end
