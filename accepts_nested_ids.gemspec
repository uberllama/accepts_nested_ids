# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'accepts_nested_ids/version'

Gem::Specification.new do |spec|
  spec.name          = "accepts_nested_ids"
  spec.version       = AcceptsNestedIds::VERSION
  spec.authors       = ["Yuval Kordov", "Little Blimp"]
  spec.email         = ["yuval@littleblimp.com"]
  spec.summary       = "Predictable nesting of associations via ID"
  spec.description   = "Defers saving of nested associations by ID, and adds dirty tracking of said associations to parent model"
  spec.homepage      = "http://github.com/uberllama/accepts_nested_ids"
  spec.license       = "MIT"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_dependency "activesupport", ">= 3.0.0"
  spec.add_development_dependency "activerecord", ">= 4.2.3"
  spec.add_development_dependency "bundler", "~> 2.2.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
