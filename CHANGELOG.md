## [Unreleased]

### 0.10.0 - 2025-4-1

- Add a note about Helper Inclusion to README
- Add ObjectInspector::InspectorsHelper#inspect! as a short form for #inspect(scope: :all)

### 0.9.0 - 2025-3-23

- Add `issues` to the (probably never-used) CombiningFormatter + Internal refactoring/cleanup.
- Update benchmark code + results info for Ruby v3.4 in README

### 0.8.2 - 2025-1-4

- Fix failure in Ruby < v3.4, found by CI test suite.

### 0.8.1 - 2025-1-4

- Fix minimum ruby version in gemspec

### 0.8.0 - 2025-1-4

- Update minimum Ruby version from 3.1 -> 3.2

### 0.7.0 - 2024-11-21

- Update minimum Ruby version from 2.7 -> 3.1

### 0.6.3 - 2023-11-21

- Internal updates to style, etc. No outward-facing changes.

### 0.6.2 - 2022-12-30

- Internal spruce-up for Ruby 3.2. No outward-facing changes.
- Remove travis-ci config since travis-ci is no longer in use.

### 0.6.1 - 2019-06-27

- Flatten and compact arrays of `nil`s as well as nested arrays of `nil`s in join\_\* methods.

### 0.6.0 - 2019-03-13

- Fix inspection of delegating wrapper objects.
- Allow clearing output of inspect methods.

### 0.5.2 - 2019-02-24

- Automatically compact nils in join\_\* methods.

### 0.5.1 - 2018-06-12

- Don't include empty strings from Scope#join\_\* methods when applicable.

### 0.5.0 - 2018-06-11

- Add `inspect_issues` to ObjectInspector::TemplatingFormatter.
- Add ObjectInspector::Scope#join_name.
- Add configurable ObjectInspector.configuration.presented_object_separator.

### 0.4.0 - 2018-05-25

- Feature: Add ObjectInspector::Configuration#default_scope setting -- can be used to override the default Scope for object inspection.
- Implement ObjectInspector::Scope#== for comparing scopes with scopes and/or scopes with (Arrays of) Strings, Symbols, etc.

### 0.3.1 - 2018-04-15

- Add ObjectInspector::Configuration#formatter_class setting for overriding the default Formatter.

### 0.3.0 - 2018-04-14

- Remove optional dependency on ActiveSupport::StringInquirer. [Scopes are now objects](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/scope.rb) that act like ActiveSupport::StringInquirer objects.
- Add ObjectInspector::Scope.join_flags helper method.
- Add ObjectInspector::Scope.join_info helper method.
- Scope: Show an out-of-scope-placeholder symbol (\*) when predicate is not matched and a block is given.
- Scope: Add wild-card "all" scope that is always evaluated as true / a match.
- Add ability to specify multiple scopes. e.g. my_object.inspect(scope: %i[verbose complex]).
- Add gem defaults configuration.

### 0.2.0 - 2018-04-12

- Automatically inspect wrapped Objects, if applicable.
- Use `display_name` if defined on object, in place of `inspect_name`.
- Add on-the-fly inspect methods when Symbols are passed in to #inspect.
- Update the `flags` and `info` demarcation symbols.
- Add ObjectInspector::TemplatingFormatter, and use it as the new default since it's faster.
- Rename ObjectInspector::DefaultFormatter to ObjectInspector::CombiningFormatter.

### 0.1.0 - 2018-04-09

- Initial release!
