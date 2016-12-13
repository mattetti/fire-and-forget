# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'fire/version'

Gem::Specification.new do |spec|
  spec.name          = "fire-and-forget"
  spec.version       = FireAndForget::VERSION
  spec.authors       = ["Matt Aimonetti"]
  spec.email         = ["mattaimonetti@gmail.com"]
  spec.description   = %q{Allows developers to fire HTTP requests and not worry about the response (only the initial connection is verified).}
  spec.summary       = %q{For whenever you need to push data to an endpoint but don't care about the response (or its status).}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", ">= 1.2"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_runtime_dependency "json", "=1.8.2"
end
