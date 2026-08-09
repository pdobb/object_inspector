# frozen_string_literal: true

require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  TestFormatter = Class.new
  private_constant :TestFormatter

  it "has a VERSION" do
    _(ObjectInspector::VERSION).wont_be_nil
  end

  describe ".configuration" do
    subject { ObjectInspector }

    it "returns an ObjectInspector::Configuration object" do
      _(subject.configuration).must_be_kind_of(ObjectInspector::Configuration)
    end

    it "contains the expected default values" do
      configuration = subject.configuration

      _(configuration.formatter_class).must_equal(
        ObjectInspector::TemplatingFormatter,
      )
      _(configuration.inspect_method_prefix).must_equal("inspect")
      _(configuration.default_scope).must_equal(ObjectInspector::Scope.new(:self))
      _(configuration.wild_card_scope).must_equal("all")
      _(configuration.out_of_scope_placeholder).must_equal("*")
      _(configuration.presented_object_separator).must_equal(
        " #{[0x21E8].pack("U")} ",
      )
      _(configuration.name_separator).must_equal(" - ")
      _(configuration.flags_separator).must_equal(" / ")
      _(configuration.issues_separator).must_equal(" | ")
      _(configuration.info_separator).must_equal(" | ")
    end
  end

  describe ".configure" do
    subject { ObjectInspector }

    given "a custom configuration" do
      before do
        subject.configure do |config|
          config.formatter_class = TestFormatter
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

        _(configuration.formatter_class).must_equal(TestFormatter)
        _(configuration.inspect_method_prefix).must_equal("ins")
        _(configuration.default_scope).must_equal(ObjectInspector::Scope.new(:custom))
        _(configuration.wild_card_scope).must_equal("WILD_CARD")
        _(configuration.out_of_scope_placeholder).must_equal("0")
        _(configuration.presented_object_separator).must_equal(";")
        _(configuration.name_separator).must_equal("|")
        _(configuration.flags_separator).must_equal("")
        _(configuration.issues_separator).must_equal("=")
        _(configuration.info_separator).must_equal("-")
      end
    end
  end

  describe ".reset_configuration" do
    subject { ObjectInspector }

    it "resets the Configuration to the expected default values" do
      configuration = subject.configuration

      _(configuration.formatter_class).must_equal(
        ObjectInspector::TemplatingFormatter,
      )
      _(configuration.inspect_method_prefix).must_equal("inspect")
      _(configuration.default_scope).must_equal(ObjectInspector::Scope.new(:self))
      _(configuration.wild_card_scope).must_equal("all")
      _(configuration.out_of_scope_placeholder).must_equal("*")
      _(configuration.presented_object_separator).must_equal(
        " #{[0x21E8].pack("U")} ",
      )
      _(configuration.name_separator).must_equal(" - ")
      _(configuration.flags_separator).must_equal(" / ")
      _(configuration.issues_separator).must_equal(" | ")
      _(configuration.info_separator).must_equal(" | ")
    end
  end

  describe "Configuration" do
    describe "#formatter_class=" do
      subject { ObjectInspector::Configuration.new }

      given "a Class constant" do
        it "sets the value as expected" do
          subject.formatter_class = TestFormatter
          _(subject.formatter_class).must_equal(TestFormatter)
        end
      end

      given "a String" do
        it "raises TypeError" do
          _(-> {
            subject.formatter_class = "STRING"
          }).must_raise(TypeError)
        end
      end
    end
  end
end
