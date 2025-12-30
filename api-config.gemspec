# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'api-config/version'

Gem::Specification.new do |gem|
  gem.name          = 'api-config'
  gem.version       = APIConfig::VERSION
  gem.authors       = ['Lleir Borras Metje', 'Marcello Barnaba']
  gem.email         = ['l.borrasmetje@ifad.org', 'm.barnaba@ifad.org']
  gem.summary       = "A nice way to configure api url's and configuratios for a ruby app."
  gem.description   = "A nice way to configure api url's and configuratios for a ruby app."
  gem.homepage      = 'https://github.com/ifad/api-config'
  gem.license       = 'MIT'

  gem.files          = Dir.glob('{LICENSE,README.md,lib/**/*.rb}', File::FNM_DOTMATCH)
  gem.require_paths  = ['lib']

  gem.required_ruby_version = '>= 3.1'

  gem.add_dependency 'ostruct'

  gem.metadata['rubygems_mfa_required'] = 'true'
end
