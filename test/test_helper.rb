require "simplecov"
SimpleCov.start do
  add_filter "/bin/"
  add_filter "/test/"
end
puts "SimpleCov enabled."

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "object_inspector"

require "minitest/autorun"
require "pry"

def context(*args, &block)
  describe(*args, &block)
end
