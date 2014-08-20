# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'csv_to_sitemap/version'

Gem::Specification.new do |spec|
  spec.name          = "csv_to_sitemap"
  spec.version       = CsvToSitemap::VERSION
  spec.authors       = ["Chris Taggart"]
  spec.email         = ["countculture@gmail.com"]
  spec.description   = %q{Converts CSV file of paths to XML sitemap collection}
  spec.summary       = %q{Converts CSV file of paths to XML sitemap collection}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
