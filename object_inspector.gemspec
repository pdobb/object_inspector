
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "object_inspector/version"

Gem::Specification.new do |spec|
  spec.name          = "object_inspector"
  spec.version       = ObjectInspector::VERSION
  spec.authors       = ["Paul Dobbins"]
  spec.email         = ["paul.dobbins@icloud.com"]

  spec.summary       = %q{ObjectInspector generates uniform inspect output with varying amounts of detail.}
  spec.description   = %q{ObjectInspector takes Object#inspect to the next level. Specify any combination of identification attributes, flags, info, and/or a display name along with a complexity level to represent an object in the console, in logging, or otherwise.}
  spec.homepage      = ""
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-byebug"
end
