# frozen_string_literal: true

require "test_helper"

class ObjectInspector::BaseFormatterTest < Minitest::Spec
  describe "ObjectInspector::BaseFormatter" do
    let(:klazz) { ObjectInspector::BaseFormatter }

    describe "#call" do
      it "raises NotImplementedError" do
        _(-> { klazz.new(Object.new).call }).must_raise(
          NotImplementedError)
      end
    end
  end
end
