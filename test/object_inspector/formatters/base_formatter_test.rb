# frozen_string_literal: true

require "test_helper"

class ObjectInspector::BaseFormatterTest < Minitest::Spec
  let(:unit_class) { ObjectInspector::BaseFormatter }

  describe "#call" do
    it "raises NotImplementedError" do
      _(-> { unit_class.new(Object.new).call }).must_raise(
        NotImplementedError)
    end
  end
end
