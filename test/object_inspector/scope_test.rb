# frozen_string_literal: true

require "test_helper"

class ObjectInspector::ScopeTest < Minitest::Spec
  let(:self_scope) { ObjectInspector::Scope.new(:self) }
  let(:verbose_scope) { ObjectInspector::Scope.new(:verbose) }
  let(:all_scope) { ObjectInspector::Scope.new(:all) }
  let(:self_and_verbose_scope) { ObjectInspector::Scope.new(%i[self verbose]) }

  describe ".new" do
    subject { ObjectInspector::Scope }

    it "defaults to just 'self' scope" do
      result = subject.new
      _(result.names).must_equal(["self"])
    end

    it "accepts a single Symbol name and converts it to a String" do
      result = subject.new(:verbose)
      _(result.names).must_equal(["verbose"])
    end

    it "accepts a single String name" do
      result = subject.new("verbose")
      _(result.names).must_equal(["verbose"])
    end

    it "accepts individually-passed names, Stringifies, and sorts them" do
      result = subject.new(:verbose, :self)
      _(result.names).must_equal(%w[self verbose])
    end

    it "accepts an Array of names, flattens, Stringifies, and sorts them" do
      result = subject.new(%i[verbose self])
      _(result.names).must_equal(%w[self verbose])
    end

    it "flattens nested Arrays of names" do
      result = subject.new([:verbose, %i[self complex]])
      _(result.names).must_equal(%w[complex self verbose])
    end

    it "converts non-String names to Strings" do
      result = subject.new(9)
      _(result.names).must_equal(["9"])
    end

    it "returns an empty names Array, GIVEN an empty Array" do
      result = subject.new([])
      _(result.names).must_equal([])
    end
  end

  describe "#join_name" do
    subject { self_scope }

    it "joins the passed in Array with the expected separator" do
      _(subject.join_name(%w[1 2 3])).must_equal("1 - 2 - 3")
    end

    it "flattens nested name" do
      _(subject.join_name([1, [2]])).must_equal("1 - 2")
    end

    it "compacts nil values" do
      _(subject.join_name([1, nil])).must_equal("1")
    end

    it "returns nil, given an empty Array" do
      _(subject.join_name([])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s" do
      _(subject.join_name([nil, nil])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s with nested arrays of `nil`s" do
      _(subject.join_name([nil, nil, [nil, nil, [nil, nil]]]))
        .must_be_nil
    end
  end

  describe "#join_flags" do
    subject { self_scope }

    it "joins the passed in Array with the expected separator" do
      _(subject.join_flags(%w[1 2 3])).must_equal("1 / 2 / 3")
    end

    it "flattens nested flags" do
      _(subject.join_flags([1, [2]])).must_equal("1 / 2")
    end

    it "compacts nil values" do
      _(subject.join_flags([1, nil])).must_equal("1")
    end

    it "returns nil, given an empty Array" do
      _(subject.join_flags([])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s" do
      _(subject.join_flags([nil, nil])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s with nested arrays of `nil`s" do
      _(subject.join_flags([nil, nil, [nil, nil, [nil, nil]]]))
        .must_be_nil
    end
  end

  describe "#join_issues" do
    subject { self_scope }

    it "joins the passed in Array with the expected separator" do
      _(subject.join_issues(%w[1 2 3])).must_equal("1 | 2 | 3")
    end

    it "flattens nested issues" do
      _(subject.join_issues([1, [2]])).must_equal("1 | 2")
    end

    it "compacts nil values" do
      _(subject.join_issues([1, nil])).must_equal("1")
    end

    it "returns nil, given an empty Array" do
      _(subject.join_issues([])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s" do
      _(subject.join_issues([nil, nil])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s with nested arrays of `nil`s" do
      _(subject.join_issues([nil, nil, [nil, nil, [nil, nil]]]))
        .must_be_nil
    end
  end

  describe "#join_info" do
    subject { self_scope }

    it "joins the passed in Array with the expected separator" do
      _(subject.join_info(%w[1 2 3])).must_equal("1 | 2 | 3")
    end

    it "flattens nested info items" do
      _(subject.join_info([1, [2]])).must_equal("1 | 2")
    end

    it "compacts nil values" do
      _(subject.join_info([1, nil])).must_equal("1")
    end

    it "returns nil, given an empty Array" do
      _(subject.join_info([])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s" do
      _(subject.join_info([nil, nil])).must_be_nil
    end

    it "returns nil, GIVEN an array of `nil`s with nested arrays of `nil`s" do
      _(subject.join_info([nil, nil, [nil, nil, [nil, nil]]]))
        .must_be_nil
    end
  end

  describe "#==" do
    subject { self_scope }

    it "returns true, GIVEN a Scope with the same #names" do
      _(subject).must_equal(ObjectInspector::Scope.new(:self))
    end

    it "returns false, GIVEN a Scope with a different #name" do
      _(subject).wont_equal(ObjectInspector::Scope.new(:other))
    end

    it "returns false, GIVEN a Scope with different #names" do
      _(subject).wont_equal(ObjectInspector::Scope.new(%i[self other]))
    end

    it "returns true, GIVEN a String with the same name" do
      _(subject == "self").must_equal(true)
    end

    it "returns true, GIVEN a Symbol with the same name" do
      _(subject == :self).must_equal(true)
    end

    it "returns false, GIVEN a String with a different name" do
      _(subject).wont_equal("other")
    end

    it "returns false, GIVEN a Symbol with a different name" do
      refute_equal(subject, :other)
    end

    it "returns false, GIVEN an Array of Symbol with a different name" do
      refute_equal(subject, %i[self other])
    end

    it "returns false, GIVEN an Array of Strings with a different name" do
      refute_equal(subject, %w[self other])
    end
  end

  describe "#to_s" do
    given "a single scope name" do
      subject { self_scope }

      it "returns a String" do
        _(subject.to_s).must_equal("self")
      end
    end

    given "multiple scope names" do
      subject { self_and_verbose_scope }

      it "returns a String" do
        _(subject.to_s).must_equal("self, verbose")
      end
    end
  end

  describe "#to_a" do
    given "a single scope name" do
      subject { self_scope }

      it "returns the names Array" do
        _(subject.to_a).must_equal(%w[self])
      end
    end

    given "multiple scope names" do
      subject { self_and_verbose_scope }

      it "returns the sorted names Array" do
        _(subject.to_a).must_equal(%w[self verbose])
      end
    end

    given "individually-passed scope names" do
      subject { ObjectInspector::Scope.new(:verbose, :self) }

      it "returns the sorted names Array" do
        _(subject.to_a).must_equal(%w[self verbose])
      end
    end
  end

  describe "#inspect" do
    given "a single scope name" do
      subject { self_scope }

      it "returns a String with the class name and names" do
        _(subject.inspect).must_equal(
          %(<ObjectInspector::Scope :: ["self"]>),
        )
      end
    end

    given "multiple scope names" do
      subject { self_and_verbose_scope }

      it "returns a String with the class name and sorted names" do
        _(subject.inspect).must_equal(
          %(<ObjectInspector::Scope :: ["self", "verbose"]>),
        )
      end
    end
  end

  describe "#<method_name>" do
    subject { self_scope }

    it "raises NoMethodError" do
      _ { subject.unknown_method }.must_raise(NoMethodError)
    end
  end

  describe "#<method_name>?" do
    given "method_name matches Scope#name" do
      subject { self_scope }

      given "no block" do
        it "returns true" do
          _(subject.self?).must_equal(true)
        end
      end

      given "a block" do
        it "evaluates the block" do
          _(subject.self? { "BLOCK_RESULT" }).must_equal("BLOCK_RESULT")
        end
      end
    end

    given "method_name does not match Scope#name" do
      subject { verbose_scope }

      given "no block" do
        it "returns false" do
          _(subject.self?).must_equal(false)
        end
      end

      given "a block" do
        it "returns the out-of-scope placeholder" do
          _(subject.self? { "BLOCK_RESULT" }).must_equal("*")
        end
      end
    end

    given "Scope#name is :all" do
      subject { all_scope }

      given "no block" do
        it "returns true, regardless of the predicate method name used" do
          _(subject.all?).must_equal(true)
          _(subject.self?).must_equal(true)
          _(subject.verbose?).must_equal(true)
        end
      end

      given "a block" do
        it "evaluates the block, regardless of the predicate method name" do
          _(subject.all? { "BLOCK_RESULT" }).must_equal("BLOCK_RESULT")
          _(subject.self? { "BLOCK_RESULT" }).must_equal("BLOCK_RESULT")
          _(subject.verbose? { "BLOCK_RESULT" }).must_equal("BLOCK_RESULT")
        end
      end
    end
  end

  describe "#respond_to?" do
    given "method_name matches Scope#name" do
      subject { self_scope }

      it "returns true" do
        _(subject.respond_to?(:self?)).must_equal(true)
      end
    end

    given "method_name does not match Scope#name" do
      subject { self_scope }

      it "returns true" do
        _(subject.verbose?).must_equal(false)
      end
    end
  end
end
