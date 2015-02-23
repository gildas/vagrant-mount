# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'vagrant-mount/version'

Gem::Specification.new do |spec|
  spec.name          = 'vagrant-mount'
  spec.version       = VagrantPlugins::Mount::VERSION
  spec.authors       = ['Gildas Cherruel']
  spec.email         = ['gildas@breizh.org']
  spec.summary       = %q{Mounts ISO in Virtual Machines}
  spec.description   = %q{Mounts ISO in Virtual Machines via the provider}
  spec.homepage      = 'http://www.vagrantup.com'
  spec.license       = 'MIT'

  spec.required_rubygems_version = '>= 1.3.6'
  spec.rubyforge_project         = 'vagrant-mount'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'yard'
end
