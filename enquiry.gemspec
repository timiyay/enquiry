# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enquiry/version'

Gem::Specification.new do |spec|
  spec.name          = 'enquiry'
  spec.version       = Enquiry::VERSION
  spec.authors       = ['Timothy Asquith']
  spec.email         = ['timothy.asquith@gmail.com']
  spec.summary       = 'Write a short summary. Required.'
  spec.description   = 'Write a longer description. Optional.'
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_runtime_dependency 'google_drive'

  # Ensure mail gem version for reduced memory footprint
  # This gem is required by 'pony' gem.
  # http://www.schneems.com/2014/11/07/i-ram-what-i-ram.html
  spec.add_runtime_dependency 'mail', '>= 2.6.3'

  spec.add_runtime_dependency 'mailchimp-api'
  spec.add_runtime_dependency 'pony'
  spec.add_runtime_dependency 'redis'
  spec.add_runtime_dependency 'sidekiq'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'faker'
  spec.add_development_dependency 'growl'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'pry-byebug'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '>=3.0.0'
  spec.add_development_dependency 'rspec-mocks'
  spec.add_development_dependency 'travis', '>=1.7.5'
end
