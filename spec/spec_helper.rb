ENV['RACK_ENV'] ||= 'test'

require 'bundler'
Bundler.require :default, ENV['RACK_ENV'].to_sym

require 'faker'
require 'pry'
require 'pry-byebug'
require 'rspec'
require 'rspec/mocks'

require 'enquiry'

def debugger
  binding.pry
end

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end
end
