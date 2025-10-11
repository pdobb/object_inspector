# frozen_string_literal: true

require_relative "lib/object_inspector/version"

Gem::Specification.new do |spec|
  spec.name = "object_inspector"
  spec.version = ObjectInspector::VERSION
  spec.authors = ["Paul DobbinSchmaltz"]
  spec.email = ["p.dobbinschmaltz@icloud.com"]

  spec.summary = "Object Inspector builds uniformly formatted inspect output with customizable amounts of detail."
  spec.description = "Object Inspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, issues, info, and/or a name along with an optional, self-definable scope option to represents objects. Great for the console, logging, etc."
  spec.homepage = "https://github.com/pdobb/object_inspector"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/pdobb/object_inspector/issues",
    "changelog_uri" => "https://github.com/pdobb/object_inspector/releases",
    "source_code_uri" => "https://github.com/pdobb/object_inspector",
    "homepage_uri" => spec.homepage,
    "rubygems_mfa_required" => "true",
  }

  # Specify which files should be added to the gem when it is released.
  spec.files =
    Dir.glob(%w[
      LICENSE.txt
      README.md
      {exe,lib}/**/*
    ]).reject { |file| File.directory?(file) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |file| File.basename(file) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "benchmark-ips"
  spec.add_development_dependency "gemwork"
  spec.add_development_dependency "object_identifier"
  spec.add_development_dependency "rake"
end
