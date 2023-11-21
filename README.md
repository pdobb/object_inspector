# Object Inspector

[![Gem Version](https://img.shields.io/github/v/release/pdobb/object_inspector)](https://img.shields.io/github/v/release/pdobb/object_inspector)
[![CI Actions](https://github.com/pdobb/object_inspector/actions/workflows/ci.yml/badge.svg)](https://github.com/pdobb/object_inspector/actions)
[![Maintainability](https://api.codeclimate.com/v1/badges/34e821263d9e0c33d536/maintainability)](https://codeclimate.com/github/pdobb/object_inspector/maintainability)

Object Inspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, issues, info, and/or a name along with an optional, self-definable scope option to represent objects. Great for the console, logging, etc.

Why? Because object inspection code should be uniform, easy to build, and its output should be easy to read!

If you'd like to just jump into an example: [Full Example](#full-example).


## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_inspector"
```

And then execute:

    $ bundle

Or install it yourself:

    $ gem install object_inspector


## Compatibility

Tested MRI Ruby Versions:
* 2.7
* 3.0
* 3.1
* 3.2

Object Inspector has no other dependencies.


## Configuration

Global/default values for Object Inspector can be configured via the ObjectInspector::Configuration object.

_Note: In a Rails app, the following would go in e.g. `config/initializers/object_inspector.rb`_

```ruby
# Default values are shown.
ObjectInspector.configure do |config|
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

Given, an object of any type, call ObjectInspector::Inspector.inspect.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(self)
  end
end

MyObject.new.inspect  # => "<MyObject>"
```

See also [Helper Usage](#helper-usage) for an even simpler usage option.


### Output Customization

Use the `identification`, `flags`, `info`, and/or `name` options to customize inspect output.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(
      self,
      identification: "My Object",
      flags: "FLAG1 / FLAG2",
      info: "INFO",
      name: "NAME")
  end
end

MyObject.new.inspect  # => "<My Object(FLAG1 / FLAG2) INFO :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and/or `inspect_name` (or `display_name`) as either public or private methods on Object.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(self)
  end

  private

  def inspect_identification; "My Object" end
  def inspect_flags; "FLAG1 / FLAG2" end
  def inspect_issues; "ISSUE1 | ISSUE2" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end  # Or: def display_name; "NAME" end
end

MyObject.new.inspect
# => "<My Object(FLAG1 / FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>"
```


## Helper Usage

To save some typing, include ObjectInspector::InspectHelper into an object and ObjectInspector::Inspector.inspect will be called on `self` automatically.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper
end

MyObject.new.inspect  # => "<MyObject>"
```

To access the ObjectInspector::Inspector's options via the helper, call into `super`.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def inspect
    super(identification: "My Object",
          flags: "FLAG1",
          issues: "ISSUE1 | ISSUE2",
          info: "INFO",
          name: "NAME")
  end
end

MyObject.new.inspect
# => "<My Object(FLAG1) !!ISSUE1 | ISSUE2!! INFO :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and/or `inspect_name` (or `display_name`) in Object.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  private

  def inspect_identification; "My Object" end
  def inspect_flags; "FLAG1 / FLAG2" end
  def inspect_issues; "ISSUE1 | ISSUE2" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end  # Or: def display_name; "NAME" end
end

MyObject.new.inspect
# => "<My Object(FLAG1) !!ISSUE1 | ISSUE2!! INFO :: NAME>"
```


## Scopes

Use the `scope` option to define the scope of the `inspect_*` methods. The supplied value will be wrapped by the ObjectInspector::Scope helper object.
The default value is `ObjectInspector::Scope.new(:self)`.


### Scope Names

ObjectInspector::Scope acts like [ActiveSupport::StringInquirer](http://api.rubyonrails.org/classes/ActiveSupport/StringInquirer.html). This is a prettier way to test for a given type of "scope" within objects.

The ObjectInspector::Scope objects in these examples are the same as specifying `<scope_name>` like this:

```ruby
my_object.inspect(scope: <scope_name>)
```


Options:
- `:self` (Default) -- Is meant to confine object interrogation to self (don't interrogate neighboring objects).
- `:all` -- Is meant to match on all scopes, regardless of their name.
- `<custom>` -- Anything else that makes sense for the object to key on.

```ruby
scope = ObjectInspector::Scope.new
scope.self?     # => true
scope.verbose?  # => false
scope.complex?  # => false
```


#### Multiple Scope Names

It is also possible to pass in multiple scope names to match on.

```ruby
scope = ObjectInspector::Scope.new(%i[verbose complex])
scope.self?     # => false
scope.verbose?  # => true
scope.complex?  # => true
```


#### The "Wild Card" Scope

Finally, `:all` is a "wild card" scope name, and will match on all scope names.

```ruby
scope = ObjectInspector::Scope.new(:all)
scope.self?     # => true
scope.verbose?  # => true
scope.complex?  # => true
```


### Scope blocks

Passing a block to a scope predicate falls back to the out-of-scope placeholder (`*` by default) if the scope does not match.

```ruby
scope = ObjectInspector::Scope.new(:verbose)
scope.verbose? { "MATCH" }  # => "MATCH"
scope.complex? { "MATCH" }  # => "*"
```


### Scope Joiners

ObjectInspector::Scope also offers helper methods for uniformly joining inspect elements:
- `join_name` -- Joins name parts with ` - ` by default
- `join_flags` -- Joins flags with ` / ` by default
- `join_info` -- Joins info items with ` | ` by default

```ruby
scope = ObjectInspector::Scope.new(:verbose)
scope.join_name([1, 2, 3])  # => "1 - 2 - 3"
scope.join_name([1, 2, 3, nil])  # => "1 - 2 - 3"
scope.join_flags([1, 2, 3])  # => "1 / 2 / 3"
scope.join_flags([1, 2, 3, nil])  # => "1 / 2 / 3"
scope.join_info([1, 2, 3])   # => "1 | 2 | 3"
scope.join_info([1, 2, 3, nil])   # => "1 | 2 | 3"
```


## Full Example

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  attr_reader :name,
              :a2

  def initialize(name, a2 = 2)
    @name = name
    @a2 = a2
  end

  def associated_object1
    OpenStruct.new(flags: "AO1_FLAG1")
  end

  def associated_object2
    OpenStruct.new(flags: "AO2_FLAG1")
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

  def inspect_issues
    "!!WARNING!!"
  end

  def inspect_info(scope:)
    info = ["Default Info"]
    info << "Complex Info" if scope.complex?
    info << scope.verbose? { "Verbose Info" }

    scope.join_info(info)
  end
end

my_object = MyObject.new("Name")

my_object.inspect(scope: :complex)
# => "<MyObject[a2:2](DEFAULT_FLAG / *) !!!!WARNING!!!! Default Info | Complex Info | * :: Name>"

my_object.inspect(scope: :verbose)
# => "<MyObject[a2:2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!!!WARNING!!!! Default Info | Verbose Info :: Name>"

my_object.inspect(scope: %i[self complex verbose])
# => "<MyObject[a2:2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!!!WARNING!!!! Default Info | Complex Info | Verbose Info :: Name>"

my_object.inspect(scope: :all)
# => "<MyObject[a2:2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!!!WARNING!!!! Default Info | Complex Info | Verbose Info :: Name>"

my_object.inspect
# => "<MyObject[a2:2](DEFAULT_FLAG / *) !!!!WARNING!!!! Default Info | * :: Name>"

ObjectInspector.configuration.default_scope = :complex
my_object.inspect
# => "<MyObject[a2:2](DEFAULT_FLAG / *) !!!!WARNING!!!! Default Info | Complex Info | * :: Name>"

ObjectInspector.configuration.default_scope = %i[self complex verbose]
my_object.inspect
# => "<MyObject[a2:2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!!!WARNING!!!! Default Info | Complex Info | Verbose Info :: Name>"

ObjectInspector.configuration.default_scope = :all
my_object.inspect
# => "<MyObject[a2:2](DEFAULT_FLAG / AO1_FLAG1 / AO2_FLAG1) !!!!WARNING!!!! Default Info | Complex Info | Verbose Info :: Name>"
```


## Wrapped Objects

If the Object being inspected wraps another object -- i.e. defines #to_model and #to_model returns an object other than self -- the inspect output will re-inspect the wrapped object. The wrapper points to the wrapped object with an arrow (⇨).

```ruby
class MyWrapperObject
  include ObjectInspector::InspectorsHelper

  def to_model
    @to_model ||= MyWrappedObject.new
  end

  private

  def inspect_flags; "WRAPPER_FLAG1" end
end

class MyWrappedObject
  include ObjectInspector::InspectorsHelper

  private

  def inspect_flags; "FLAG1 / FLAG2" end
  def inspect_info; "INFO" end
end

MyWrapperObject.new.inspect
# => "<MyWrapperObject(WRAPPER_FLAG1)> ⇨ <MyWrappedObject(FLAG1 / FLAG2) INFO>"
```

This feature is recursive.


### Wrapped Delegators

If the Object being inspected is wrapped by an object that delegates all unknown methods to the wrapped object, then inspect flags will be doubled up. To get around this, redefine the `inspect` method in the Wrapper object e.g. like:

```ruby
class MyDelegatingWrapperObject
  include ObjectInspector::InspectorsHelper

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
  include ObjectInspector::InspectorsHelper

  def display_name
    "WRAPPED_OBJECT_NAME"
  end

  private

  def inspect_flags; "FLAG1" end
  def inspect_info; "INFO" end
  def inspect_issues; "ISSUE1" end
  def inspect_name; "NAME" end
end

MyDelegatingWrapperObject.new(MyWrappedObject.new).inspect
# => "<MyDelegatingWrapperObject>  ⇨  <MyWrappedObject(FLAG1) !!ISSUE1!! INFO :: NAME>"
```


## On-the-fly Inspect Methods

When passed as an option (as opposed to being called via an Object-defined method) symbols will be called/evaluated on Object on the fly.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def my_method1; "Result1" end
  def my_method2; "Result2" end

  def inspect_info; :my_method2 end
end

MyObject.new.inspect(info: "my_method1")  # => "<MyObject my_method1>"
MyObject.new.inspect(info: :my_method2)   # => "<MyObject Result2>"
MyObject.new.inspect                      # => "<MyObject my_method2>"
```

## Clearing Output for Specified Inspect Method

Pass `nil` to any inspect method type to not display it:

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def inspect_identification; "My Object" end
  def inspect_info; "INFO" end
  def inspect_flags; "FLAG1" end
  def inspect_issues; "ISSUE1" end
end

MyObject.new.inspect
# => "<My Object(FLAG1) !!ISSUE1!! INFO>"
MyObject.new.inspect(info: nil, flags: nil, issues: nil)
# => "<My Object>"
MyObject.new.inspect(identification: nil, info: nil, flags: nil, issues: nil)
# => "<MyObject>"
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
  include ObjectInspector::InspectorsHelper

  def inspect
    super(formatter: MyCustomFormatter,
          identification: "IDENTIFICATION",
          flags: "FLAG1 / FLAG2",
          info: "INFO",
          name: "NAME")
  end
end

MyObject.new.inspect
# => "[IDENTIFICATION Flags: FLAG1 / FLAG2 -- Info: INFO -- Name: NAME]"
```

See examples:
- [ObjectInspector::TemplatingFormatter]
- [ObjectInspector::CombiningFormatter]


## Supporting Gems

Object Inspector works great with the [Object Identifier](https://github.com/pdobb/object_identifier) gem.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

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

  def inspect_flags; "FLAG1 / FLAG2" end
  def inspect_issues; "ISSUE1 | ISSUE2" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end
end

MyObject.new.inspect
# => "<MyObject[my_method1:1, my_method2:2](FLAG1 / FLAG2) !!ISSUE1 | ISSUE2!! INFO :: NAME>"
```


## Performance

### Benchmarking Object Inspector

ObjectInspetor is ~4x slower than Ruby's default inspect.

Performance of Object Inspector can be tested by playing the [Object Inspector Benchmarking Script](https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/object_inspector.rb) in the pry console for this gem.

```ruby
play script/benchmarking/object_inspector.rb
# Comparison:
#                 Ruby:    30382.2 i/s
# ObjectInspector::Inspector:     7712.2 i/s - 3.94x  slower
```


### Benchmarking Formatters

[ObjectInspector::TemplatingFormatter] -- which is the default Formatter -- outperforms [ObjectInspector::CombiningFormatter] by about 30% on average.

Performance of Formatters can be tested by playing the [Formatters Benchmarking Scripts](https://github.com/pdobb/object_inspector/blob/master/script/benchmarking/formatters.rb) in the pry console for this gem.

```ruby
play script/benchmarking/formatters.rb
# == Averaged =============================================================
# ...
#
# Comparison:
# ObjectInspector::TemplatingFormatter:    45725.3 i/s
# ObjectInspector::CombiningFormatter:    34973.9 i/s - 1.31x  slower
#
# == Done
```


#### Benchmarking Custom Formatters

Custom Formatters may be similarly gauged for comparison by adding them to the `custom_formatter_klasses` array before playing the script.

```ruby
custom_formatter_klasses = [MyCustomFormatter]

play script/benchmarking/formatters.rb
# == Averaged =============================================================
# ...
#
# Comparison:
#    MyCustomFormatter:    52001.2 i/s
# ObjectInspector::TemplatingFormatter:    49854.2 i/s - same-ish: difference falls within error
# ObjectInspector::CombiningFormatter:    38963.5 i/s - 1.33x  slower
#
# == Done
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. Or, run `rake` to run the tests plus linters as well as `yard` (to confirm proper YARD documentation practices). You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`.

To release a new version, update the version number in `version.rb`, bump the latest ruby target versions etc. with `rake bump`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

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
