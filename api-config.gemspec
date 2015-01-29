# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'api_config'

Gem::Specification.new do |spec|
  spec.name          = "api-config"
  spec.version       = APIConfig::VERSION
  spec.authors       = ["Lleir Borras Metje"]
  spec.email         = ["l.borrasmetje@ifad.org"]
  spec.summary       = %q{A nice way to configure api url's and configuratios for a ruby app.}
  spec.description   = %q{A nice way to configure api url's and configuratios for a ruby app.}
  spec.homepage      = "http://code.ifad.org/api-config"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
