# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'weship/version'

Gem::Specification.new do |spec|
  spec.name          = "weship"
  spec.version       = Weship::VERSION
  spec.authors       = ["Roman Sotnikov"]
  spec.email         = ["roman.sotnikov@gmail.com"]
  spec.description   = "Provide access to weship(io) API"
  spec.summary       = "Ruby bindings for weship(io) API"
  spec.homepage      = "http://weship.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'oauth2-client'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
