# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'errordite/version'

Gem::Specification.new do |spec|
  spec.name          = "errordite-rails"
  spec.version       = Errordite::VERSION
  spec.authors       = ["Tom Ward"]
  spec.email         = ["tom@popdog.net"]
  spec.description   = %q{A rails client for www.errordite.com}
  spec.summary       = %q{A rails client for www.errordite.com}
  spec.homepage      = "https://www.errordite.com"
  spec.license       = "MIT"

  spec.files         = ["lib/errordite-rails.rb", "lib/errordite/version.rb"]
  spec.require_paths = ["lib"]

  spec.add_dependency "errordite", Errordite::VERSION
  spec.add_dependency "rails"
end
