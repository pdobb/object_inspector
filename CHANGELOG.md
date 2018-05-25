### Unreleased
- Add ObjectInspector::Configuration#default_scope setting -- can be used to override the default Scope for object inspection.
- Implement ObjectInspector::Scope#== for comparing scopes with scopes and/or scopes with (Arrays of) Strings, Symbols, etc.


### 0.3.1 - 2018-04-15
- Add ObjectInspector::Configuration#formatter_class setting for overriding the default Formatter.


### 0.3.0 - 2018-04-14

- Remove optional dependency on ActiveSupport::StringInquirer. [Scopes are now objects](https://github.com/pdobb/object_inspector/blob/master/lib/object_inspector/scope.rb) that act like ActiveSupport::StringInquirer objects.
- Add ObjectInspector::Scope.join_flags helper method.
- Add ObjectInspector::Scope.join_info helper method.
- Scope: Show an out-of-scope-placeholder symbol (*) when predicate is not matched and a block is given.
- Scope: Add wild-card "all" scope that is always evaluated as true / a match.
- Add ability to specify multiple scopes. e.g. my_object.inspect(scope: %i[verbose complex])
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
