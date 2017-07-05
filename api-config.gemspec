# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'api-config'

Gem::Specification.new do |spec|
  spec.name          = 'api-config'
  spec.version       = APIConfig::VERSION
  spec.authors       = ['Lleir Borras Metje', 'Marcello Barnaba']
  spec.email         = ['l.borrasmetje@ifad.org', 'm.barnaba@ifad.org']
  spec.summary       = %q{A nice way to configure api url's and configuratios for a ruby app.}
  spec.description   = %q{A nice way to configure api url's and configuratios for a ruby app.}
  spec.homepage      = 'http://code.ifad.org/api-config'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'bundler'
  spec.add_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
