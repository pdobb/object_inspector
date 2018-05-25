require "test_helper"

class ObjectInspector::ScopeTest < Minitest::Spec
  class SimpleTestObject
  end

  describe ObjectInspector::Scope do
    let(:klazz) { ObjectInspector::Scope }

    let(:self_scope) { klazz.new(:self) }
    let(:verbose_scope) { klazz.new(:verbose) }
    let(:all_scope) { klazz.new(:all) }
    let(:self_and_verbose_scope) { klazz.new(%i[self verbose]) }

    describe "#==" do
      subject { self_scope }

      it "returns true, GIVEN a Scope with the same #names" do
        assert subject == klazz.new(:self)
      end

      it "returns false, GIVEN a Scope with a different #name" do
        refute subject == klazz.new(:other)
      end

      it "returns false, GIVEN a Scope with different #names" do
        refute subject == klazz.new([:self, :other])
      end

      it "returns true, GIVEN a String with the same name" do
        assert subject == "self"
      end

      it "returns true, GIVEN a Symbol with the same name" do
        assert subject == :self
      end

      it "returns false, GIVEN a String with a different name" do
        refute subject == "other"
      end

      it "returns false, GIVEN a Symbol with a different name" do
        refute subject == :other
      end

      it "returns false, GIVEN an Array of Symbol with a different name" do
        refute subject == %i[self other]
      end

      it "returns false, GIVEN an Array of Strings with a different name" do
        refute subject == %w[self other]
      end
    end

    describe "#to_s" do
      context "GIVEN a single scope name" do
        subject { self_scope }

        it "returns a String" do
          subject.to_s.must_equal "self"
        end
      end

      context "GIVEN multiple scope names" do
        subject { self_and_verbose_scope }

        it "returns a String" do
          subject.to_s.must_equal "self, verbose"
        end
      end
    end

    describe "#<method_name>" do
      subject { self_scope }

      it "raises NoMethodError" do
        -> { subject.unknown_method }.must_raise NoMethodError
      end
    end

    describe "#<method_name>?" do
      context "GIVEN method_name matches Scope#name" do
        subject { self_scope }

        context "GIVEN no block" do
          it "returns true" do
            subject.self?.must_equal true
          end
        end

        context "GIVEN a block" do
          it "evaluates the block" do
            subject.self? { "BLOCK_RESULT" }.must_equal "BLOCK_RESULT"
          end
        end
      end

      context "GIVEN method_name does not match Scope#name" do
        subject { verbose_scope }

        context "GIVEN no block" do
          it "returns false" do
            subject.self?.must_equal false
          end
        end

        context "GIVEN a block" do
          it "returns the out-of-scope placeholder" do
            subject.self? { "BLOCK_RESULT" }.must_equal "*"
          end
        end
      end

      context "GIVEN Scope#name is :all" do
        subject { all_scope }

        context "GIVEN no block" do
          it "returns true, regardless of the predicate method name used" do
            subject.all?.must_equal true
            subject.self?.must_equal true
            subject.verbose?.must_equal true
          end
        end

        context "GIVEN a block" do
          it "evaluates the block, regardless of the predicate method name used" do
            subject.all? { "BLOCK_RESULT" }.must_equal "BLOCK_RESULT"
            subject.self? { "BLOCK_RESULT" }.must_equal "BLOCK_RESULT"
            subject.verbose? { "BLOCK_RESULT" }.must_equal "BLOCK_RESULT"
          end
        end
      end
    end

    describe "#respond_to?" do
      context "GIVEN method_name matches Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.respond_to?(:self?).must_equal true
        end
      end

      context "GIVEN method_name does not match Scope#name" do
        subject { self_scope }

        it "returns true" do
          subject.verbose?.must_equal false
        end
      end
    end

    describe "#join_flags" do
      subject { self_scope }

      it "joins the passed in Array with the expected separator" do
        subject.join_flags(%w[1 2 3]).must_equal("1 / 2 / 3")
      end

      it "flattens nested flags" do
        subject.join_flags([1, [2]]).must_equal("1 / 2")
      end
    end

    describe "#join_info" do
      subject { self_scope }

      it "joins the passed in Array with the expected separator" do
        subject.join_info(%w[1 2 3]).must_equal("1 | 2 | 3")
      end

      it "flattens nested info items" do
        subject.join_info([1, [2]]).must_equal("1 | 2")
      end
    end
  end
end
