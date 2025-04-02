# frozen_string_literal: true

require "test_helper"

class ObjectInspector::ConversionsTest < Minitest::Spec
  describe "ObjectInspector::Conversions" do
    let(:unit_class) { ObjectInspector::Conversions }

    let(:scope1) { ObjectInspector::Scope.new }

    describe ".Scope" do
      subject { unit_class }

      given "an ObjectInspector::Scope" do
        it "returns the same ObjectInspector::Scope" do
          _(unit_class.Scope(scope1).object_id).must_equal(scope1.object_id)
        end
      end

      given "a Symbol" do
        it "returns a new Scope for the given Symbol" do
          new_scope = unit_class.Scope(:verbose)
          _(new_scope.names).must_include("verbose")
        end
      end
    end
  end
end
