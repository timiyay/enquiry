require 'sidekiq'

if ENV['RACK_ENV'] == 'production'
  require 'newrelic_rpm'
  require 'raygun4ruby'
  require 'raygun/sidekiq'

  # Setup Raygun exception tracker
  Raygun.setup do |config|
    config.api_key = ENV['RAYGUN_APIKEY']
  end
end

# Tune Redis concurrency to avoid Redis errors
# when exceeding maxclients limit of 10 on
# Redistogo Nano instances
Sidekiq.configure_client do |config|
  config.redis = { size: 2 }
end

Sidekiq.configure_server do |config|
  config.redis = { size: 4 }
end

require_relative './contact_notification'
require_relative './google_drive'
require_relative './mailchimp'
