require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  it "has_a_version_number" do
    ::ObjectInspector::VERSION.wont_be_nil
  end
end
