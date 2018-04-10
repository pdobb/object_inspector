# ObjectInspector

[![Gem Version](https://badge.fury.io/rb/object_inspector.svg)](https://badge.fury.io/rb/object_inspector)
[![Build Status](https://travis-ci.org/objects-on-rails/display-case.svg?branch=master)](https://travis-ci.org/objects-on-rails/display-case)
[![Test Coverage](https://api.codeclimate.com/v1/badges/34e821263d9e0c33d536/test_coverage)](https://codeclimate.com/github/pdobb/object_inspector/test_coverage)
[![Maintainability](https://api.codeclimate.com/v1/badges/34e821263d9e0c33d536/maintainability)](https://codeclimate.com/github/pdobb/object_inspector/maintainability)

ObjectInspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, info, and/or a name along with a self-definable scope option to represent an object in the console, in logging, or otherwise.


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

Given, an object of any type, call ObjectInspector::Inspect#to_s.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.new(self).to_s
  end
end

MyObject.new.inspect  # => "<MyObject>"
```

Or, just use the ObjectInspector::Inspector.inspect method.

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

Use ObjectInspector::Inspector#initialize options -- `identification`, `flags`, `info`, and `name` -- to customize inspect output.

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

MyObject.new.inspect  # => "<My Object[FLAG1] (INFO) :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and `inspect_name` in Object.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(self)
  end

private

  def inspect_identification
    "My Object"
  end

  def inspect_flags
    "FLAG1"
  end

  def inspect_info
    "INFO"
  end

  def inspect_name
    "NAME"
  end
end

MyObject.new.inspect  # => "<My Object[FLAG1] (INFO) :: NAME>"
```


## Helper Usage

To save some typing, include ObjectInspector::InspectHelper into an object and ObjectInspector::Inspector#to_s will be called for you on `self`.

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

MyObject.new.inspect  # => "<My Object[FLAG1] (INFO) :: NAME>"
```

Or, define `inspect_identification`, `inspect_flags`, `inspect_info`, and `inspect_name` in Object.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

private

  def inspect_identification
    "My Object"
  end

  def inspect_flags
    "FLAG1"
  end

  def inspect_info
    "INFO"
  end

  def inspect_name
    "NAME"
  end
end

MyObject.new.inspect  # => "<My Object[FLAG1] (INFO) :: NAME>"
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

MyObject.new.inspect  # => "<MyObject[FLAG1]>"
MyObject.new.inspect(scope: :all)  # => "<MyObject[FLAG1 / FLAG2]>"
```


## Custom Formatters

A custom inspect formatter can be defined by implementing the interface defined by [ObjectInspector::BaseFormatter](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/base_formatter.rb) and then passing that into ObjectInspector::Inspector.new.

```ruby
class MyCustomFormatter < ObjectInspector::BaseFormatter
  def call
    "(#{combine_strings})"
  end

private

  def build_identification_string(identification = self.identification)
    identification.to_s
  end

  def build_flags_string(flags = self.flags)
    " #{flags}" if flags
  end

  def build_info_string(info = self.info)
    " (#{info})" if info
  end

  def build_name_string(name = self.name)
    " -- #{name}" if name
  end
end

class MyObject
  include ObjectInspector::InspectorsHelper

  def inspect
    super(formatter: MyCustomFormatter)
  end

private

  def inspect_identification
    "IDENTIFICATION"
  end

  def inspect_flags
    "FLAG1"
  end

  def inspect_info
    "INFO"
  end

  def inspect_name
    "NAME"
  end
end

MyObject.new.inspect  # => "(IDENTIFICATION FLAG1 (INFO) -- NAME)"
```

See also: [ObjectInspector::DefaultFormatter](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/default_formatter.rb).


## Supporting Gems

ObjectInspector works great with the [ObjectIdentifier](https://github.com/pdobb/object_identifier) gem.

```ruby
class MyObject
  include ObjectInspector::InspectorsHelper

  def my_method1
    "R1"
  end

  def my_method1
    "R1"
  end

private

  def inspect_identification
    identify(:m1, :m2)
  end

  def inspect_flags
    "FLAG1"
  end

  def inspect_info
    "INFO"
  end

  def inspect_name
    "NAME"
  end
end

MyObject.new.inspect  # => "<MyObject[m1:R1, m2:R2][FLAG1] (INFO) :: NAME>"
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pdobb/object_inspector.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
