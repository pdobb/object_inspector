# Object Inspector

[![Gem Version](https://img.shields.io/github/v/release/pdobb/object_inspector)](https://img.shields.io/github/v/release/pdobb/object_inspector)
[![CI Actions](https://github.com/pdobb/object_inspector/actions/workflows/ci.yml/badge.svg)](https://github.com/pdobb/object_inspector/actions)

Object Inspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, issues, info, and/or a name along with an optional, self-definable scope option to represent objects. Great for the console, logging, etc.

Why? Because object inspection output should be uniform and easy to build, and its output should be easy to read! Consistency improves readability.

If you'd like to just jump into an example: [Full Example](#full-example).

## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_inspector"
```

And then execute:

```sh
$ bundle
```

Or install it yourself:

```sh
$ gem install object_inspector
```

## Compatibility

Tested MRI Ruby Versions:

- 3.2
- 3.3
- 3.4

For Ruby 2.7 support, install object_inspector gem version 0.6.3.

```ruby
gem "object_inspector", "0.6.3"
```

For Ruby 3.1 support, install object_inspector gem version 0.7.0.

```ruby
gem "object_inspector", "0.7.0"
```

Object Inspector has no other dependencies.

## Configuration

Global/default values for Object Inspector can be configured via the [ObjectInspector::Configuration] object.

```ruby
# config/initializers/object_inspector.rb

# Default values are shown. Customize to your liking.
ObjectInspector.configure do |config|
  config.enabled = true
  config.formatter_class = ObjectInspector::TemplatingFormatter
  config.inspect_method_prefix = "inspect"
  config.default_scope = ObjectInspector::Scope.new(:self)
  config.wild_card_scope = "all"
  config.out_of_scope_placeholder = "*"
  config.presenter_inspect_flags = " ⇨ "
  config.name_separator = " - "
  config.flags_separator = " / "
  config.issues_separator = " | "
  config.info_separator = " | "
end
```

## Usage

Including `ObjectInspector::InspectBehaviors` into an object will cause `ObjectInspector::Inspector.inspect` to be called on `self` automatically.

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors
end

MyObject.new.inspect # =>
"<MyObject>"

# NOTE: IRB's Pretty Print processor calls `inspect` and unwraps the quotes:
MyObject.new # =>
<MyObject>
```

Build out the inspect String by defining any of: `inspect_identification`, `inspect_flags`, `inspect_info`, and `inspect_name` (or `display_name`).

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors

  private

  def inspect_identification = "My Object"
  def inspect_flags = "FLAG1 / FLAG2"
  def inspect_issues = "ISSUE1 | ISSUE2"
  def inspect_info = "INFO"
  def inspect_name = "NAME"  # Or: def display_name = "NAME"
end

MyObject.new # =>
<My Object(FLAG1) !!ISSUE1 | ISSUE2!! INFO :: NAME>
```

### Customizing `ObjectInspector::InspectBehaviors`

Instead of including `ObjectInspector::InspectBehaviors` directly, it may be useful to define your own mix-in.

```ruby
module ObjectInspectionBehaviors
  include ObjectInspector::InspectBehaviors

  # For defining #inspect chains.
  def introspect
    # { self => ... }
    self
  end
end
```

## Scopes

Use the `scope` option to define when each of the `inspect_*` methods should be included. The default scope is `:self`, or `ObjectInspector::Scope.new(:self)`.

### Scope Names

ObjectInspector::Scope acts like an [ActiveSupport::StringInquirer](http://api.rubyonrails.org/classes/ActiveSupport/StringInquirer.html).

Call `inspect` with a scope name like:

```ruby
my_object.inspect(scope: <scope_name>)
```

#### Default Scope Names:

The default scope is: `:self`.

- `:self` (Default): Is meant to restrict object interrogation to self.

#### Custom Scope Names:

Beyond just `:self`, any name can be used to define any scope that makes sense for your project. No need to provision them up front, just start using them! Suggested additional scope names include:

- `:verbose`: For extra detail that may not normally be needed.
- `:complex`: For revealing collaborating objects (used to prevent n+1 queries in the normal case)

```ruby
def inspect(scope:)
  scope.inspect     # => <ObjectInspector::Scope :: ["self"]>
  scope.self?       # => true
  scope.verbose?    # => false
  scope.complex?    # => false
  scope.<anything>? # => false
end
```

#### Multiple Scope Names

It is also possible to pass in multiple scope names to match on.

```ruby
def inspect(scope: %i[verbose complex])
  scope.inspect  # => <ObjectInspector::Scope :: ["complex", "verbose"]>
  scope.self?    # => false
  scope.verbose? # => true
  scope.complex? # => true
end
```

#### The "Wild Card" Scope

Finally, `:all` is a "wild card" scope name, and will match on all scope names.

```ruby
def inspect(scope: :all)
  scope.inspect  # => <ObjectInspector::Scope :: ["all"]>
  scope.self?    # => true
  scope.verbose? # => true
  scope.complex? # => true
  scope.all?     # => true
end
```

_**NOTE**_: Calling `#inspect!` on an object that mixes in `ObjectInspector::InspectBehaviors` is equivalent to passing in the "wild card" scope.

### Scope blocks

Passing a block to a scope predicate falls back to the out-of-scope placeholder (`*` by default) if the scope does not match.

```ruby
scope = ObjectInspector::Scope.new(:verbose)
scope.verbose? { "MATCH" } # => "MATCH"
scope.complex? { "MATCH" } # => "*"
```

### Scope Joiners

ObjectInspector::Scope also offers helper methods for uniformly joining inspect elements:

```ruby
scope.join_name   # Joins name parts with ` - ` by default
scope.join_flags  # Joins flags with ` / ` by default
scope.join_issues # Joins issues with ` | ` by default
scope.join_info   # Joins info items with ` | ` by default
```

For example:

```ruby
scope = ObjectInspector::Scope.new(:all)
scope.join_name([1, 2, 3, nil])   # => "1 - 2 - 3"
scope.join_flags([1, 2, 3, nil])  # => "1 / 2 / 3"
scope.join_issues([1, 2, 3, nil]) # => "1 | 2 | 3"
scope.join_info([1, 2, 3, nil])   # => "1 | 2 | 3"
```

## Full Example

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors

  attr_reader :name,
              :a2

  def initialize(name, a2 = 2)
    @name = name
    @a2 = a2
  end

  def associated_object1
    Data.define(:flags)["AO1_FLAG1"]
  end

  def associated_object2
    Data.define(:flags)["AO2_FLAG1"]
  end

  # Or `def inspect_name`
  def display_name(scope:)
    name
  end

  private

  def inspect_identification
    identify(:a2)
  end

  def inspect_flags(scope:)
    flags = ["DEFAULT_FLAG"]

    flags <<
      scope.verbose? {
        [
          associated_object1.flags,
          associated_object2.flags,
        ]
      }

    scope.join_flags(flags)
  end

  def inspect_issues(scope:)
    scope.join_issues([
      "I1",
      scope.verbose? { "VI2" },
    ])
  end

  def inspect_info(scope:)
    info = ["Default Info"]
    info << "Complex Info" if scope.complex?
    info << scope.verbose? { "Verbose Info" }

    scope.join_info(info)
  end
end

my_object = MyObject.new("Name")

my_object.inspect
# => "<MyObject[2](DEFAULT_FLAG / *) !!I1 | *!! Default Info | * :: Name>"

my_object.inspect(scope: :self)
# => "<MyObject[2](DEFAULT_FLAG / *) !!I1 | *!! Default Info | * :: Name>"

my_object.inspect(scope: :complex)
# => "<MyObject[2](DEFAULT_FLAG / *) !!I1 | *!! Default Info | Complex Info | * :: Name>"

my_object.inspect(scope: :verbose)
# => "<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Verbose Info :: Name>"

my_object.inspect(scope: %i[self complex verbose])
# => "<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Complex Info | Verbose Info :: Name>"

my_object.inspect(scope: :all)
# => "<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Complex Info | Verbose Info :: Name>"

my_object.inspect! # 👀 Same as passing in `scope: :all`
# => "<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Complex Info | Verbose Info :: Name>"

ObjectInspector.configuration.default_scope = :complex
my_object # =>
<MyObject[2](DEFAULT_FLAG / *) !!I1 | *!! Default Info | Complex Info | * :: Name>

ObjectInspector.configuration.default_scope = %i[self complex verbose]
my_object # =>
<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Complex Info | Verbose Info :: Name>

ObjectInspector.configuration.default_scope = :all
my_object # =>
<MyObject[2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!I1 | VI2!! Default Info | Complex Info | Verbose Info :: Name>
```

## Wrapped Objects

If the Object being inspected wraps another object--i.e. defines #to_model and #to_model returns an object other than self--the inspect output will re-inspect the wrapped object. The wrapper points to the wrapped object with an arrow (⇨).

```ruby
class MyWrapperObject
  include ObjectInspector::InspectBehaviors

  def to_model
    @to_model ||= MyWrappedObject.new
  end

  private

  def inspect_flags = "WRAPPER_FLAG1"
  def inspect_issues(scope:) = scope.complex? { "CI1" }
end

class MyWrappedObject
  include ObjectInspector::InspectBehaviors

  private

  def inspect_flags = "FLAG1 / FLAG2"
  def inspect_info = "INFO"
  def inspect_issues(scope:) = scope.complex? { "CI1" }
end

MyWrapperObject.new # =>
<MyWrapperObject(WRAPPER_FLAG1) !!*!!>  ⇨  <MyWrappedObject(FLAG1 / FLAG2) !!*!! INFO>

MyWrapperObject.new! # =>
<MyWrapperObject(WRAPPER_FLAG1) !!CI1!!>  ⇨  <MyWrappedObject(FLAG1 / FLAG2) !!CI1!! INFO>
```

This feature is recursive.

### Wrapped Delegators

If the Object being inspected is wrapped by an object that delegates all unknown methods to the wrapped object, then inspect flags will be doubled up. To get around this, redefine the `inspect` method in the Wrapper object e.g. like:

```ruby
class MyDelegatingWrapperObject
  include ObjectInspector::InspectBehaviors

  def initialize(my_object)
    @my_object = my_object
  end

  def inspect(**kwargs)
    super(identification: self.class.name,
          name: nil,
          flags: nil,
          info: nil,
          issues: nil,
          **kwargs)
  end

  def to_model
    @my_object
  end

  private

  def method_missing(method_symbol, *args)
    @my_object.__send__(method_symbol, *args)
  end

  def respond_to_missing?(*args)
    @my_object.respond_to?(*args) || super
  end
end

class MyWrappedObject
  include ObjectInspector::InspectBehaviors

  def display_name
    "WRAPPED_OBJECT_NAME"
  end

  private

  def inspect_flags = "FLAG1"
  def inspect_info = "INFO"
  def inspect_issues = "ISSUE1"
  def inspect_name = "NAME"
end

MyDelegatingWrapperObject.new(MyWrappedObject.new) # =>
<MyDelegatingWrapperObject>  ⇨  <MyWrappedObject(FLAG1) !!ISSUE1!! INFO :: NAME>
```

## On-the-fly Inspect Methods

When passed as an option (as opposed to being called via an Object-defined method) symbols will be called/evaluated on Object on the fly.

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors

  def my_method1 = "Result1"
  def my_method2 = "Result2"

  def inspect_info = :my_method2
end

MyObject.new.inspect(info: "my_method1") # => "<MyObject my_method1>"
MyObject.new.inspect(info: :my_method2)  # => "<MyObject Result2>"
MyObject.new.inspect                     # => "<MyObject my_method2>"
```

## Clearing Output for Specified Inspect Method

Pass `nil` to any inspect method type to not display it:

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors

  def inspect_identification = "My Object"
  def inspect_info = "INFO"
  def inspect_flags = "FLAG1"
  def inspect_issues = "ISSUE1"
  def inspect_name = "NAME"
end

MyObject.new.inspect
# => "<My Object(FLAG1) !!ISSUE1!! INFO :: NAME>"
MyObject.new.inspect(info: nil, flags: nil, issues: nil)
# => "<My Object :: NAME>"
MyObject.new.inspect(identification: nil, info: nil, flags: nil, issues: nil, name: nil)
# => "<MyObject>"
```

## Temporarily Disabling ObjectInspector

You may disable / re-enable Object Inspector output (via the included helper method) for the current session:

```ruby
MyObject.new # =>
<My Object(FLAG1 / FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>

ObjectInspector.configuration.disable # =>
 -> ObjectInspector disabled
MyObject.new # =>
#<MyObject:0x000000012332c458>

ObjectInspector.configuration.enable # =>
 -> ObjectInspector enabled
MyObject.new # =>
<My Object(FLAG1 / FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>
```

Or, simply toggle the current state:

```ruby
ObjectInspector.configuration.toggle; # =>
 -> ObjectInspector disabled

ObjectInspector.configuration.toggle; # =>
 -> ObjectInspector enabled
```

## Custom Formatters

A custom inspect formatter can be defined by implementing the interface defined by [ObjectInspector::BaseFormatter](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/base_formatter.rb). Then, either override the ObjectInspector::Configuration#formatter_class value (see [Configuration](#configuration)) or just pass your custom class name into ObjectInspector::Inspector.new.

```ruby
class MyCustomFormatter < ObjectInspector::BaseFormatter
  def call
    "[#{identification} Flags: #{flags} -- Info: #{info} -- Name: #{name}]"
  end
end

class MyObject
  include ObjectInspector::InspectBehaviors

  def inspect
    super(
      formatter: MyCustomFormatter,
      identification: "IDENTIFICATION",
      flags: "FLAG1 / FLAG2",
      info: "INFO",
      name: "NAME")
  end
end

MyObject.new # =>
[IDENTIFICATION Flags: FLAG1 / FLAG2 -- Info: INFO -- Name: NAME]
```

See examples:

- [ObjectInspector::TemplatingFormatter]
- [ObjectInspector::CombiningFormatter]

## Help

### How can I see the original inspect output on ActiveRecord objects?

Simply [disable Object Inspector](#disabling-object-inspector) and you'll see ActiveRecord's Pretty Print formatting shine through again. For example:

```ruby
class User < ApplicationRecord
  include ObjectInspectionBehaviors # 👀 Defined above.

  # ...
end

User.new # =>
<User[1] :: John Smith>

ObjectInspector.configuration.disable; # =>
 -> ObjectInspector disabled

User.new # =>
#<User:0x0000000125ce9890
 id: "6c6d6f4b-05fd-4d81-af3e-1947a6a38aa0",
 first_name: "John",
 last_name: "Smith",
 time_zone: nil,
 created_at: "2025-02-10 12:27:23.793833000 -0600",
 updated_at: "2025-02-11 13:15:00.301991000 -0600">
```

## Supporting Gems

Object Inspector works great with the [Object Identifier](https://github.com/pdobb/object_identifier) gem.

```ruby
class MyObject
  include ObjectInspector::InspectBehaviors

  def my_method1
    1
  end

  def my_method2
    2
  end

  private

  def inspect_identification
    identify(:my_method1, :my_method2)
  end

  def inspect_flags = "FLAG1 / FLAG2"
  def inspect_issues = "ISSUE1 | ISSUE2"
  def inspect_info = "INFO"
  def inspect_name = "NAME"
end

MyObject.new # =>
<MyObject[my_method1:1, my_method2:2](FLAG1 / FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>
```

## Adding Utilities Methods to `.irbrc` / `.pryrc`

One may wish to add some convenience methods to their project-local `.irbrc`/`.pryrc` file, and/or their global `~/.irbrc`/`~/.pryrc` file. For example:

```ruby
# OBJECT INSPECTOR GEM

def toggle_object_inspector = ObjectInspector.configuration.toggle
alias oit toggle_object_inspector

def get_object_inspector_current_scope
  ObjectInspector.configuration.default_scope
end
alias oi get_object_inspector_current_scope

# :simple is the default inspection scope.
def set_object_inspector_scope_simple = set_object_inspector_scope(:simple)
alias ois set_object_inspector_scope_simple

def set_object_inspector_scope_complex = set_object_inspector_scope(:complex)
alias oic set_object_inspector_scope_complex

def set_object_inspector_scope_verbose = set_object_inspector_scope(:verbose)
alias oiv set_object_inspector_scope_verbose

# Set :all (wild-card) inspection scope.
def set_object_inspector_scope_all = set_object_inspector_scope(:all)
alias oia set_object_inspector_scope_all

# Set a custom scope or set of scopes.
#
# @example
#   set_object_inspector_scope(:my_custom_scope)
#   set_object_inspector_scope(:complex, :verbose)
#   set_object_inspector_scope(%i[complex verbose my_custom_scope])
def set_object_inspector_scope(*names)
  ObjectInspector.configuration.default_scope = *names
  get_object_inspector_current_scope
end
alias oiset set_object_inspector_scope
```

## Performance

### Benchmarking Object Inspector

ObjectInspetor is ~2.75x slower than Ruby's default inspect, in Ruby v3.4.

Performance of Object Inspector can be tested by playing the [Object Inspector Benchmarking Script](https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/object_inspector.rb) in the IRB console for this gem.

```ruby
load "script/benchmarking/object_inspector.rb"
# Reporting for: Ruby v3.4.2
#
# == Averaged =============================================================
# ...
#
# Comparison:
#                 Ruby:    58957.2 i/s
# ObjectInspector::Inspector:    21416.6 i/s - 2.75x  slower
# == Done
```

### Benchmarking Formatters

[ObjectInspector::TemplatingFormatter]--which is the default Formatter--outperforms [ObjectInspector::CombiningFormatter] by about 30% on average.

Performance of Formatters can be tested by playing the [Formatters Benchmarking Scripts](https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/formatters.rb) in the IRB console for this gem.

```ruby
load "script/benchmarking/formatters.rb"
# Reporting for: Ruby v3.4.2
#
# == Averaged =============================================================
# ...
#
# Comparison:
# ObjectInspector::TemplatingFormatter:    65856.3 i/s
# ObjectInspector::CombiningFormatter:    60920.0 i/s - 1.13x  slower
# == Done
```

#### Benchmarking Custom Formatters

Custom Formatters may be similarly gauged for comparison by putting them into a constant `CUSTOM_FORMATTER_CLASSES` before loading the script in the IRB console for this gem.

```ruby
CUSTOM_FORMATTER_CLASSES = [MyCustomFormatter]

load "script/benchmarking/formatters.rb"
# Reporting for: Ruby v3.4.2
#
# == Averaged =============================================================
# ...
#
# Comparison:
#    MyCustomFormatter:    74227.7 i/s
# ObjectInspector::TemplatingFormatter:    66148.5 i/s - 1.12x  slower
# ObjectInspector::CombiningFormatter:    63289.7 i/s - 1.17x  slower
# == Done
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. Or, run `rake` to run the tests plus linters as well as `yard` (to confirm proper YARD documentation practices). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

### Testing

To test this gem:

```sh
rake
```

#### Linters

```sh
rubocop

reek

npx prettier . --check
npx prettier . --write
```

### Releases

To release a new version of this gem to RubyGems:

1. Update the version number in `version.rb`
2. Update `CHANGELOG.md`
3. Run `bundle` to update Gemfile.lock with the latest version info
4. Commit the changes. e.g. `Bump to vX.Y.Z`
5. Run `rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### Documentation

[YARD documentation](https://yardoc.org/index.html) can be generated and viewed live:

1. Install YARD: `gem install yard`
2. Run the YARD server: `yard server --reload`
3. Open the live documentation site: `open http://localhost:8808`

While the YARD server is running, documentation in the live site will be auto-updated on source code save (and site reload).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdobb/object_inspector.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

[ObjectInspector::TemplatingFormatter]: https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/templating_formatter.rb
[ObjectInspector::CombiningFormatter]: https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/combining_formatter.rb
[Object Inspector Benchmarking Scripts]: https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/object_inspector.rb
[Formatters Benchmarking Scripts]: https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/formatters.rb
