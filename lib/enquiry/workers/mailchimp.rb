require 'sidekiq'
require 'enquiry/services/mailchimp'

module Enquiry
  class MailchimpWorker
    include Sidekiq::Worker

    def perform(mailchimp_params)
      mailchimp_params = Enquiry::Utils.symbolize_keys(mailchimp_params)

      MailchimpService.add_contact_to_list(
        mailchimp_params[:list_id],
        mailchimp_params[:email],
        merge_params: mailchimp_params[:merge_params]
      )
    end
  end
end
