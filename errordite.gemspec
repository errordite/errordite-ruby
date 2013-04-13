# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errordite/version'

Gem::Specification.new do |spec|
  spec.name          = "errordite"
  spec.version       = Errordite::VERSION
  spec.authors       = ["Tom Ward"]
  spec.email         = ["tom@popdog.net"]
  spec.description   = %q{A ruby client for www.errordite.com}
  spec.summary       = %q{A ruby client for www.errordite.com}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "json"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "rb-fsevent"
  spec.add_development_dependency "guard-rspec"
end
