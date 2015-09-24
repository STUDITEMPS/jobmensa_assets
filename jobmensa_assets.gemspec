# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jobmensa_assets/version'

Gem::Specification.new do |spec|
  spec.name          = "jobmensa_assets"
  spec.version       = JobmensaAssets::VERSION
  spec.authors       = ["Jobmensa dev team"]
  spec.email         = ["produkt@studitemps.de"]
  spec.summary       = %q{Our image resize and delivery app.}
  spec.description   = %q{Resizes and delivers images using the refile gem.}
  spec.homepage      = "http://studitemps.tech"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'sinatra'
  spec.add_dependency 'refile'
  spec.add_dependency 'refile-s3'
  spec.add_dependency 'refile-mini_magick'
  spec.add_dependency 'rack'
  spec.add_dependency 'degu'

  spec.add_development_dependency "bundler", "~> 1.7"
end
