# frozen_string_literal: true

require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  describe ObjectInspector do
    let(:klazz) { ObjectInspector }
    let(:configuration_klazz) { ObjectInspector::Configuration }
    let(:scope_klazz) { ObjectInspector::Scope }

    it "has a VERSION" do
      value(klazz::VERSION).wont_be_nil
    end

    describe ".configuration" do
      subject { klazz }

      it "returns an ObjectInspector::Configuration object" do
        value(subject.configuration).must_be_kind_of(configuration_klazz)
      end

      it "contains the expected default values" do
        configuration = subject.configuration

        value(configuration.formatter_class).must_equal(klazz::TemplatingFormatter)
        value(configuration.inspect_method_prefix).must_equal("inspect")
        value(configuration.default_scope).must_equal(scope_klazz.new(:self))
        value(configuration.wild_card_scope).must_equal("all")
        value(configuration.out_of_scope_placeholder).must_equal("*")
        value(configuration.presented_object_separator).must_equal(" #{[0x21E8].pack("U")} ")
        value(configuration.name_separator).must_equal(" - ")
        value(configuration.flags_separator).must_equal(" / ")
        value(configuration.issues_separator).must_equal(" | ")
        value(configuration.info_separator).must_equal(" | ")
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
            config.issues_separator = "="
            config.info_separator = "-"
          end
        end

        after { subject.reset_configuration }

        it "sets custom configuration and converts values to frozen Strings" do
          configuration = subject.configuration

          value(configuration.formatter_class).must_equal(OpenStruct)
          value(configuration.inspect_method_prefix).must_equal("ins")
          value(configuration.default_scope).must_equal(scope_klazz.new(:custom))
          value(configuration.wild_card_scope).must_equal("WILD_CARD")
          value(configuration.out_of_scope_placeholder).must_equal("0")
          value(configuration.presented_object_separator).must_equal(";")
          value(configuration.name_separator).must_equal("|")
          value(configuration.flags_separator).must_equal("")
          value(configuration.issues_separator).must_equal("=")
          value(configuration.info_separator).must_equal("-")
        end
      end
    end

    describe ".reset_configuration" do
      subject { klazz }

      it "resets the Configuration to the expected default values" do
        configuration = subject.configuration

        value(configuration.formatter_class).must_equal(klazz::TemplatingFormatter)
        value(configuration.inspect_method_prefix).must_equal("inspect")
        value(configuration.default_scope).must_equal(scope_klazz.new(:self))
        value(configuration.wild_card_scope).must_equal("all")
        value(configuration.out_of_scope_placeholder).must_equal("*")
        value(configuration.presented_object_separator).must_equal(" #{[0x21E8].pack("U")} ")
        value(configuration.name_separator).must_equal(" - ")
        value(configuration.flags_separator).must_equal(" / ")
        value(configuration.issues_separator).must_equal(" | ")
        value(configuration.info_separator).must_equal(" | ")
      end
    end

    describe "Configuration" do
      describe "#formatter_class=" do
        subject { configuration_klazz.new }

        context "GIVEN a Class constant" do
          it "sets the value as expected" do
            subject.formatter_class = OpenStruct
            value(subject.formatter_class).must_equal(OpenStruct)
          end
        end

        context "GIVEN a String" do
          it "raises TypeError" do
            value(-> { subject.formatter_class = "STRING" }).must_raise(TypeError)
          end
        end
      end
    end
  end
end
