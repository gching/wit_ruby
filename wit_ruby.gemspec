# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'wit_ruby/version'

Gem::Specification.new do |spec|
  spec.name          = "wit_ruby"
  spec.version       = Wit::VERSION
  spec.authors       = ["Gavin Ching"]
  spec.email         = ["gavinchingy@gmail.com"]
  spec.description   = %q{Provides a Ruby API wrapper with the Wit.ai API.}
  spec.summary       = %q{Provides a Ruby API wrapper with the Wit.ai API.}
  spec.homepage      = "https://github.com/gching/wit_ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = ">= 1.9.3"
  spec.add_dependency('multi_json', '>= 1.3.0')

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
end
