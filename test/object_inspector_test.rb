require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  describe ObjectInspector do
    let(:klazz) { ObjectInspector }
    let(:configuration_klazz) { ObjectInspector::Configuration }
    let(:scope_klazz) { ObjectInspector::Scope }

    it "has a VERSION" do
      klazz::VERSION.wont_be_nil
    end

    describe ".configuration" do
      subject { klazz }

      it "returns an ObjectInspector::Configuration object" do
        subject.configuration.must_be_kind_of configuration_klazz
      end

      it "contains the expected default values" do
        configuration = subject.configuration

        configuration.formatter_class.must_equal klazz::TemplatingFormatter
        configuration.inspect_method_prefix.must_equal "inspect"
        configuration.default_scope.must_equal scope_klazz.new(:self)
        configuration.wild_card_scope.must_equal "all"
        configuration.out_of_scope_placeholder.must_equal "*"
        configuration.presented_object_separator.
          must_equal " #{[0x21E8].pack("U")} "
        configuration.name_separator.must_equal " - "
        configuration.flags_separator.must_equal " / "
        configuration.info_separator.must_equal " | "
      end
    end

    describe ".configure" do
      subject { klazz }

      context "GIVEN a custom configuration" do
        before do
          subject.configure do |config|
            config.formatter_class = OpenStruct
            config.inspect_method_prefix = "ins"
            config.default_scope = :custom
            config.wild_card_scope = :WILD_CARD
            config.out_of_scope_placeholder = 0
            config.presented_object_separator = ";"
            config.name_separator = "|"
            config.flags_separator = nil
            config.info_separator = "-"
          end
        end

        after { subject.reset_configuration }

        it "sets custom configuration and converts values to frozen Strings" do
          configuration = subject.configuration

          configuration.formatter_class.must_equal OpenStruct
          configuration.inspect_method_prefix.must_equal "ins"
          configuration.default_scope.must_equal scope_klazz.new(:custom)
          configuration.wild_card_scope.must_equal "WILD_CARD"
          configuration.out_of_scope_placeholder.must_equal "0"
          configuration.presented_object_separator.must_equal ";"
          configuration.name_separator.must_equal "|"
          configuration.flags_separator.must_equal ""
          configuration.info_separator.must_equal "-"
        end
      end
    end

    describe ".reset_configuration" do
      subject { klazz }

      it "resets the Configuration to the expected default values" do
        configuration = subject.configuration

        configuration.formatter_class.must_equal klazz::TemplatingFormatter
        configuration.inspect_method_prefix.must_equal "inspect"
        configuration.default_scope.must_equal scope_klazz.new(:self)
        configuration.wild_card_scope.must_equal "all"
        configuration.out_of_scope_placeholder.must_equal "*"
        configuration.presented_object_separator.
          must_equal " #{[0x21E8].pack("U")} "
        configuration.name_separator.must_equal " - "
        configuration.flags_separator.must_equal " / "
        configuration.info_separator.must_equal " | "
      end
    end

    describe "Configuration" do
      describe "#formatter_class=" do
        subject { configuration_klazz.new }

        context "GIVEN a Class constant" do
          it "sets the value as expected" do
            subject.formatter_class = OpenStruct
            subject.formatter_class.must_equal OpenStruct
          end
        end

        context "GIVEN a String" do
          it "raises TypeError" do
            -> { subject.formatter_class = "STRING" }.must_raise TypeError
          end
        end
      end
    end
  end
end
