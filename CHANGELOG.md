### Unreleased

* Rename ObjectInspector::DefaultFormatter to ObjectInspector::CombiningFormatter.
* Add ObjectInspector::TemplatingFormatter, and use it as the new default since it's faster.
* Update the `flags` and `info` demarcation symbols.

#### TODO
* Add "placeholder" symbol (*) for scope exclusions.
* Convert scope symbols to ActiveSupport::StringInquirer, if defined.
* Use `display_name` if defined on object, in place of `inspect_name`.
* Add WrappedObjectForamtter for presenters.


### 0.1.0 - 2018-04-09

* Initial release!
