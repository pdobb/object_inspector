require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  describe ObjectInspector do
    let(:klazz) { ObjectInspector }
    let(:configuration_klazz) { ObjectInspector::Configuration }

    it "has_a_version_number" do
      klazz::VERSION.wont_be_nil
    end

    describe ".configuration" do
      subject { klazz }

      it "returns an ObjectInspector::Configuration object" do
        subject.configuration.must_be_kind_of configuration_klazz
      end

      it "contains the expected default values" do
        configuration = subject.configuration

        result = configuration.wild_card_scope
        result.must_equal "all"
        result.must_be :frozen?

        result = configuration.out_of_scope_placeholder
        result.must_equal "*"
        result.must_be :frozen?

        result = configuration.flags_separator
        result.must_equal " / "
        result.must_be :frozen?

        result = configuration.info_separator
        result.must_equal " | "
        result.must_be :frozen?

        result = configuration.inspect_method_prefix
        result.must_equal "inspect"
        result.must_be :frozen?
      end
    end

    describe ".configure" do
      subject { klazz }

      context "GIVEN a custom configuration" do
        before do
          subject.configure do |config|
            config.wild_card_scope = :WILD_CARD
            config.out_of_scope_placeholder = 0
            config.flags_separator = nil
            config.info_separator = "-"
            config.inspect_method_prefix = "ins"
          end
        end

        after { subject.reset_configuration }

        it "sets custom configuration and converts values to frozen Strings" do
          configuration = subject.configuration

          result = configuration.wild_card_scope
          result.must_equal "WILD_CARD"
          result.must_be :frozen?

          result = configuration.out_of_scope_placeholder
          result.must_equal "0"
          result.must_be :frozen?

          result = configuration.flags_separator
          result.must_equal ""
          result.must_be :frozen?

          result = configuration.info_separator
          result.must_equal "-"
          result.must_be :frozen?

          result = configuration.inspect_method_prefix
          result.must_equal "ins"
          result.must_be :frozen?
        end
      end
    end

    describe ".reset_configuration" do
      subject { klazz }

      it "resets the Configuration to the expected default values" do
        configuration = subject.configuration

        result = configuration.wild_card_scope
        result.must_equal "all"
        result.must_be :frozen?

        result = configuration.out_of_scope_placeholder
        result.must_equal "*"
        result.must_be :frozen?

        result = configuration.flags_separator
        result.must_equal " / "
        result.must_be :frozen?

        result = configuration.info_separator
        result.must_equal " | "
        result.must_be :frozen?

        result = configuration.inspect_method_prefix
        result.must_equal "inspect"
        result.must_be :frozen?
      end
    end
  end
end
