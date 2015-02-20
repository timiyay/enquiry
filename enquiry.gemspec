# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enquiry/version'

Gem::Specification.new do |spec|
  spec.name          = 'enquiry'
  spec.version       = Enquiry::VERSION
  spec.authors       = ['Timothy Asquith']
  spec.email         = ['timothy.asquith@gmail.com']
  spec.summary       = "After your site's contact form is submitted, run standard background jobs"
  spec.description   = %w(
    After a user submits your site's contact form, 'enquiry' will help you run
    your post-submit actions. These actions will be run as separate processes, by plugging
    in to a Ruby-based worker library like Sidekiq.

    It currently has support for:
    * sending notification emails to the site owner
    * subscribing the enquiry to a Mailchimp list
    * adding the enquiry's details to a Google Sheet
  )
  spec.homepage      = 'https://github.com/timiyay/enquiry'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.0.0'

  spec.add_runtime_dependency 'google_drive'
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
