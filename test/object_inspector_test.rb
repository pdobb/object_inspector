# frozen_string_literal: true

require "test_helper"

class ObjectInspectorTest < Minitest::Spec
  it "has a VERSION" do
    _(ObjectInspector::VERSION).wont_be_nil
  end

  describe ".configuration" do
    subject { ObjectInspector }

    it "returns an ObjectInspector::Configuration object" do
      _(subject.configuration).must_be_instance_of(ObjectInspector::Configuration)
    end
  end

  describe ".configure" do
    subject { ObjectInspector }

    given "a custom configuration" do
      after do
        subject.reset_configuration
      end

      it "sets custom configuration and converts values to frozen Strings" do
        subject.configure do |config|
          config.formatter_class = TestFormatter
          config.inspect_method_prefix = "test"
          config.default_scope = :custom
          config.wild_card_scope = :WILD_CARD
          config.out_of_scope_placeholder = 0
          config.presented_object_separator = ";"
          config.name_separator = "|"
          config.flags_separator = nil
          config.issues_separator = "="
          config.info_separator = "-"
        end

        result = subject.configuration

        _(result.formatter_class).must_equal(TestFormatter)
        _(result.inspect_method_prefix).must_equal("test")
        _(result.default_scope).must_equal(ObjectInspector::Scope.new(:custom))
        _(result.wild_card_scope).must_equal("WILD_CARD")
        _(result.out_of_scope_placeholder).must_equal("0")
        _(result.presented_object_separator).must_equal(";")
        _(result.name_separator).must_equal("|")
        _(result.flags_separator).must_equal("")
        _(result.issues_separator).must_equal("=")
        _(result.info_separator).must_equal("-")
      end
    end
  end

  describe ".reset_configuration" do
    subject { ObjectInspector }

    it "resets the memoized Configuration object" do
      before = subject.instance_variable_get(:@configuration)
      subject.reset_configuration
      after = subject.instance_variable_get(:@configuration)

      _(before.object_id).wont_equal(after.object_id)
    end
  end

  describe "Configuration" do
    before do
      MuchStub.on_call($stdout, :puts) { |call| @puts_call = call }
    end

    describe ".new" do
      subject { ObjectInspector::Configuration }

      it "uses the expected defaults" do
        result = subject.new

        _(result).must_be(:enabled?)
        _(result.formatter_class).must_equal(ObjectInspector::TemplatingFormatter)
        _(result.inspect_method_prefix).must_equal("inspect")
        _(result.default_scope).must_equal(ObjectInspector::Scope.new(:self))
        _(result.wild_card_scope).must_equal("all")
        _(result.out_of_scope_placeholder).must_equal("*")
        _(result.presented_object_separator).must_equal(
          " #{[0x21E8].pack("U")} ",
        )
        _(result.name_separator).must_equal(" - ")
        _(result.flags_separator).must_equal(" / ")
        _(result.issues_separator).must_equal(" | ")
        _(result.info_separator).must_equal(" | ")
      end
    end

    describe "#toggle" do
      given "#enabled == true" do
        subject { ObjectInspector::Configuration.new(enabled: true) }

        it "disables the configuration and prints a status message" do
          subject.toggle

          _(subject).wont_be(:enabled?)
          _(@puts_call.args).must_equal([" -> ObjectInspector disabled"])
        end
      end

      given "#enabled == false" do
        subject { ObjectInspector::Configuration.new(enabled: false) }

        it "enables the configuration and prints a status message" do
          subject.toggle

          _(subject).must_be(:enabled?)
          _(@puts_call.args).must_equal([" -> ObjectInspector enabled"])
        end
      end
    end

    describe "#enabled?" do
      given "#enabled == true" do
        subject { ObjectInspector::Configuration.new(enabled: true) }

        it "returns true" do
          _(subject).must_be(:enabled?)
        end
      end

      given "#enabled == false" do
        subject { ObjectInspector::Configuration.new(enabled: false) }

        it "returns false" do
          _(subject).wont_be(:enabled?)
        end
      end
    end

    describe "#enable" do
      given "#enabled == false" do
        subject { ObjectInspector::Configuration.new(enabled: false) }

        it "enables the configuration and prints a status message" do
          subject.enable

          _(subject).must_be(:enabled?)
          _(@puts_call.args).must_equal([" -> ObjectInspector enabled"])
        end
      end
    end

    describe "#disabled?" do
      given "#enabled == true" do
        subject { ObjectInspector::Configuration.new(enabled: true) }

        it "returns false" do
          _(subject).wont_be(:disabled?)
        end
      end

      given "#enabled == false" do
        subject { ObjectInspector::Configuration.new(enabled: false) }

        it "returns true" do
          _(subject).must_be(:disabled?)
        end
      end
    end

    describe "#disable" do
      given "#enabled == true" do
        subject { ObjectInspector::Configuration.new(enabled: true) }

        it "disables the configuration and prints a status message" do
          subject.disable

          _(subject).must_be(:disabled?)
          _(@puts_call.args).must_equal([" -> ObjectInspector disabled"])
        end
      end
    end

    describe "#formatter_class=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given Class" do
        subject.formatter_class = TestFormatter
        _(subject.formatter_class).must_equal(TestFormatter)
      end

      it "raises TypeError for a non-Class value" do
        _ { subject.formatter_class = "STRING" }.must_raise(TypeError)
      end
    end

    describe "#inspect_method_prefix=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given prefix, converts to String, and freezes it" do
        subject.inspect_method_prefix = :test
        _(subject.inspect_method_prefix).must_equal("test")
        _(subject.inspect_method_prefix).must_be(:frozen?)
      end
    end

    describe "#default_scope=" do
      subject { ObjectInspector::Configuration.new }

      it "converts the given value to a Scope" do
        subject.default_scope = :test
        _(subject.default_scope).must_be_instance_of(ObjectInspector::Scope)
        _(subject.default_scope.names).must_equal(["test"])
      end
    end

    describe "#wild_card_scope=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given scope, converts to String, and freezes it" do
        subject.wild_card_scope = :test
        _(subject.wild_card_scope).must_equal("test")
        _(subject.wild_card_scope).must_be(:frozen?)
      end
    end

    describe "#out_of_scope_placeholder=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given placeholder, converts to String, and freezes it" do
        subject.out_of_scope_placeholder = :test
        _(subject.out_of_scope_placeholder).must_equal("test")
        _(subject.out_of_scope_placeholder).must_be(:frozen?)
      end
    end

    describe "#presented_object_separator=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given separator, converts to String, and freezes it" do
        subject.presented_object_separator = :test
        _(subject.presented_object_separator).must_equal("test")
        _(subject.presented_object_separator).must_be(:frozen?)
      end
    end

    describe "#name_separator=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given separator, converts to String, and freezes it" do
        subject.name_separator = :test
        _(subject.name_separator).must_equal("test")
        _(subject.name_separator).must_be(:frozen?)
      end
    end

    describe "#flags_separator=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given separator, converts to String, and freezes it" do
        subject.flags_separator = :test
        _(subject.flags_separator).must_equal("test")
        _(subject.flags_separator).must_be(:frozen?)
      end
    end

    describe "#issues_separator=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given separator, converts to String, and freezes it" do
        subject.issues_separator = :test
        _(subject.issues_separator).must_equal("test")
        _(subject.issues_separator).must_be(:frozen?)
      end
    end

    describe "#info_separator=" do
      subject { ObjectInspector::Configuration.new }

      it "sets the given separator, converts to String, and freezes it" do
        subject.info_separator = :test
        _(subject.info_separator).must_equal("test")
        _(subject.info_separator).must_be(:frozen?)
      end
    end
  end

  TestFormatter = Class.new
  private_constant :TestFormatter
end
