require 'sidekiq'
require_relative '../services/contact'

class ContactNotificationWorker
  include Sidekiq::Worker

  def perform(contact_params)
    ContactService.new(contact_params).send_notification_email
  end
end
