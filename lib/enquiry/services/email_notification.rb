require 'pony'
require 'enquiry/errors'

module Enquiry
  # EmailNotificationService
  #
  # Sends emails to a recipient, notifying them of a recent
  # enquiry from their website
  module EmailNotificationService
    # This service is currently a module, as there's no real need
    # to instantiate a class to use it. It will be converted to a class
    # in future, if this situation changes.

    module_function

    def deliver(to: nil, from: nil, subject: 'New enquiry from your website',
                body: 'You just received a new enquiry from your website', provider: {})
      invalid_params = {
        to: to,
        from: from,
        provider_address: provider[:address],
        provider_password: provider[:password],
        provider_user_name: provider[:user_name]
      }.select { |_k, v| v.nil? }

      fail Enquiry::ConfigError, "Missing config variables: #{invalid_params.keys}" unless invalid_params.empty?

      mailer_method = provider.delete(:method) || :smtp
      via_defaults = { port: '587', authentication: :plain }

      Pony.mail to: to, from: from, subject: subject, body: body, via: mailer_method, via_options: via_defaults.merge(provider)
    end
  end
end
