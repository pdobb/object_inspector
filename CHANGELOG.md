#### TODO
* Add "placeholder" symbol (*) for scope exclusions.
* Add gem defaults configuration.


### 0.2.0 - 2018-04-12

* Automatically inspect wrapped Objects, if applicable.
* Use `display_name` if defined on object, in place of `inspect_name`.
* Add on-the-fly inspect methods when Symbols are passed in to #inspect.
* Update the `flags` and `info` demarcation symbols.
* Add ObjectInspector::TemplatingFormatter, and use it as the new default since it's faster.
* Rename ObjectInspector::DefaultFormatter to ObjectInspector::CombiningFormatter.


### 0.1.0 - 2018-04-09

* Initial release!
