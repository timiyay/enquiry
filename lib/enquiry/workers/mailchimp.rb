require 'sidekiq'
require_relative '../services/mailchimp'

class MailchimpWorker
  include Sidekiq::Worker

  def perform(email, merge_params)
    MailchimpService.add_contact_to_list(email, merge_params: merge_params)
  end
end
