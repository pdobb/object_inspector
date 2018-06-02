require "test_helper"

module ObjectInspector
  class InspectorsHelperTest < Minitest::Spec
    class SimpleTestObject
      include ObjectInspector::InspectorsHelper
    end

    describe ObjectInspector::InspectorsHelper do
      let(:simple_object1) { SimpleTestObject.new }

      it "calls ObjectInspector::Inspector from Object#inspect" do
        simple_object1.inspect.
          must_equal "<ObjectInspector::InspectorsHelperTest::SimpleTestObject>"
      end
    end
  end
end
