# ObjectInspector

ObjectInspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, info, and/or a display name along with a complexity level to represent an object in the console, in logging, or otherwise.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "object_inspector"
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install object_inspector

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

See also [Helper](#helper) for an even simpler usage option.

### Output Customization

Use ObjectInspector::Inspector#initialize's `identification`, `flags`, `info`, and `name` options to customize inspect output.

```ruby
class MyObject
  def inspect
    ObjectInspector::Inspector.inspect(
      self,
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

## Helper

To save a little typing, include ObjectInspector::InspectHelper into an object and  ObjectInspector::Inspector#to_s will be called for you on `self`.

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

## Supporting Libraries

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
