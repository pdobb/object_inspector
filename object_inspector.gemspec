lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "object_inspector/version"

Gem::Specification.new do |spec|
  spec.name          = "object_inspector"
  spec.version       = ObjectInspector::VERSION
  spec.authors       = ["Paul Dobbins"]
  spec.email         = ["paul.dobbins@icloud.com"]

  spec.summary       = "ObjectInspector builds uniformly formatted inspect output with customizable amounts of detail."
  spec.description   = "ObjectInspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, info, and/or a name along with an optional, self-definable scope option to represents objects. Great for the console, logging, etc."
  spec.homepage      = "https://github.com/pdobb/object_inspector"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  # if spec.respond_to?(:metadata)
  #   spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  # else
  #   raise "RubyGems 2.0 or newer is required to protect against " \
  #     "public gem pushes."
  # end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "benchmark-ips", "~> 2.7"
  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "byebug", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "minitest-reporters", "~> 1.2"
  spec.add_development_dependency "object_identifier", "~> 0.1"
  spec.add_development_dependency "pry", "~> 0.11"
  spec.add_development_dependency "pry-byebug", "~> 3.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "reek", "~> 4.8"
  spec.add_development_dependency "rubocop", "~> 0.55"
  spec.add_development_dependency "simplecov", "~> 0.16"
end
