require 'sidekiq'
require 'enquiry/services/email_notification'

module Enquiry
  class EmailNotificationWorker
    include Sidekiq::Worker

    def perform(email_params)
      email_params = Enquiry::Utils.symbolize_keys(email_params)

      EmailNotificationService.deliver(
        to: email_params[:to],
        from: email_params[:from],
        subject: email_params[:subject],
        body: email_params[:body],
        provider: email_params[:provider]
      )
    end
  end
end
