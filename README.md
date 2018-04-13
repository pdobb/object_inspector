# ObjectInspector

[![Gem Version](https://badge.fury.io/rb/object_inspector.svg)](https://badge.fury.io/rb/object_inspector)
[![Build Status](https://travis-ci.org/objects-on-rails/display-case.svg?branch=master)](https://travis-ci.org/objects-on-rails/display-case)
[![Test Coverage](https://api.codeclimate.com/v1/badges/34e821263d9e0c33d536/test_coverage)](https://codeclimate.com/github/pdobb/object_inspector/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/34e821263d9e0c33d536/maintainability)](https://codeclimate.com/github/pdobb/object_inspector/maintainability)

ObjectInspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, info, and/or a name along with an optional self-definable scope option to represent an object in the console, in logging, etc.


## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_inspector"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_inspector


## Compatibility

Tested MRI Ruby Versions:
* 2.2.10
* 2.3.7
* 2.4.4
* 2.5.1


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

Use the `identification`, `flags`, `info`, and `name` options to customize inspect output.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(self,
                                       identification: "My Object",
                                       flags: "FLAG1",
                                       info: "INFO",
                                       name: "NAME")
  end
end

MyObject.new.inspect  # => "<My Object(FLAG1) INFO :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and `inspect_name` as either public or private methods on Object.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(self)
  end

private

  def inspect_identification; "My Object" end
  def inspect_flags; "FLAG1" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end
end

MyObject.new.inspect  # => "<My Object(FLAG1) INFO :: NAME>"
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
          info: "INFO",
          name: "NAME")
  end
end

MyObject.new.inspect  # => "<My Object(FLAG1) INFO :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and `inspect_name` in Object.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

private

  def inspect_identification; "My Object" end
  def inspect_flags; "FLAG1" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end
end

MyObject.new.inspect  # => "<My Object(FLAG1) INFO :: NAME>"
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


#### Scope

Use the `scope` option to define the scope of the `inspect_*` methods.

If ActiveSupport::StringInquirer is defined then the default `scope` is `"self".inquiry`.
The default value is `:self` if ActiveSupport::StringInquirer is not defined.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def inspect_flags(scope:, separator: " / ".freeze)
    flags = ["FLAG1"]

    # If ActiveSupport::StringInquirer is defined, use this:
    # flags << "FLAG2" if scope.all?

    # If ActiveSupport::StringInquirer is not defined, use this:
    flags << "FLAG2" if scope == :all

    flags.join(separator)
  end
end

MyObject.new.inspect               # => "<MyObject(FLAG1)>"
MyObject.new.inspect(scope: :all)  # => "<MyObject(FLAG1 / FLAG2)>"
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

  def inspect_flags; "FLAG1" end
  def inspect_info; "INFO" end
end

MyWrapperObject.new.inspect
# => "<MyWrapperObject(WRAPPER_FLAG1)> ⇨ <MyWrappedObject(FLAG1) INFO>"
```

This feature is recursive.


## Custom Formatters

A custom inspect formatter can be defined by implementing the interface defined by [ObjectInspector::BaseFormatter](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/base_formatter.rb) and then passing that into ObjectInspector::Inspector.new.

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
          flags: "FLAG1 | FLAG2",
          info: "INFO",
          name: "NAME")
  end
end

MyObject.new.inspect
# => "[IDENTIFICATION Flags: FLAG1 | FLAG2 -- Info: INFO -- Name: NAME]"
```

See also: [ObjectInspector::TemplatingFormatter].
See also: [ObjectInspector::CombiningFormatter].


## Performance

### Benchmarking ObjectInspector

ObjectInspetor is ~4x slower than Ruby's default inspect.

Performance of ObjectInspect can be tested by playing the [ObjectInspector Benchmarking Scripts] in the pry console for this gem.

```ruby
play scripts/benchmarking/object_inspector.rb
# Comparison:
#                 Ruby:    30382.2 i/s
# ObjectInspector::Inspector:     7712.2 i/s - 3.94x  slower
```


### Benchmarking Formatters

[ObjectInspector::TemplatingFormatter] -- which is the default Formatter -- outperforms [ObjectInspector::CombiningFormatter] by about 30% on average.

Performance of Formatters can be tested by playing the [Formatters Benchmarking Scripts] in the pry console for this gem.

```ruby
play scripts/benchmarking/formatters.rb
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

play scripts/benchmarking/formatters.rb
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


## Supporting Gems

ObjectInspector works great with the [ObjectIdentifier](https://github.com/pdobb/object_identifier) gem.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def my_method1
    "Result1"
  end

  def my_method2
    "Result2"
  end

private

  def inspect_identification; identify(:my_method1, :my_method2) end
  def inspect_flags; "FLAG1" end
  def inspect_info; "INFO" end
  def inspect_name; "NAME" end
end

MyObject.new.inspect
# => "<MyObject[my_method1:Result1, my_method2:Result2](FLAG1) INFO :: NAME>"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdobb/object_inspector.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).


[ObjectInspector::TemplatingFormatter]: https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/templating_formatter.rb
[ObjectInspector::CombiningFormatter]: https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/formatters/combining_formatter.rb
[ObjectInspector Benchmarking Scripts]: https://github.com/pdobb/object_inspector/blob/master/scripts/benchmarking/object_inspector.rb
[Formatters Benchmarking Scripts]: https://github.com/pdobb/object_inspector/blob/master/scripts/benchmarking/formatters.rb
