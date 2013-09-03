# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'crawler/version'

Gem::Specification.new do |spec|
  spec.name          = "crawler"
  spec.version       = Crawler::VERSION
  spec.authors       = ["MQuy"]
  spec.email         = ["sugiacupit@gmail.com"]
  spec.description   = %q{Auto get and parse information on websites}
  spec.summary       = %q{Web Crawler}
  spec.homepage      = "https://github.com/MQuy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rake"
  spec.add_dependency "nokogiri"
  spec.add_dependency "curb"
  spec.add_dependency "rack"
  spec.add_dependency "bundler"
  spec.add_dependency "chronic"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-rails"
end
