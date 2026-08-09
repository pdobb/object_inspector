# frozen_string_literal: true

require "test_helper"

class ObjectInspector::BaseFormatterTest < Minitest::Spec
  describe "#call" do
    it "raises NotImplementedError" do
      _ { ObjectInspector::BaseFormatter.new(Object.new).call }.must_raise(
        NotImplementedError,
      )
    end
  end
end
