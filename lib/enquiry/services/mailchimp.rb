require 'mailchimp'
require 'enquiry/errors'

module Enquiry
  # MailchimpService
  #
  # Provides a proxy to Mailchimp API actions, including:
  #   - subscribing a contact to a Mailchimp list
  class MailchimpService
    EMAIL_TYPE = 'html'
    DOUBLE_OPTIN = true
    UPDATE_EXISTING = true

    attr_accessor :api_key, :list_id

    def self.add_contact_to_list(list_id, email, api_key: nil, merge_params: {})
      MailchimpService.new(list_id, email, api_key: api_key, merge_params: merge_params).subscribe
    end

    def initialize(list_id, email, api_key: nil, merge_params: {})
      @api_key = api_key || ENV['ENQUIRY_MAILCHIMP_API_KEY']
      @email = email
      @list_id = list_id || ENV['ENQUIRY_MAILCHIMP_LIST_ID']
      @merge_params = merge_params
      validate_config
    end

    def subscribe
      Mailchimp::API.new(api_key).lists.subscribe(
        list_id,
        { email: @email },
        @merge_params,
        EMAIL_TYPE,
        DOUBLE_OPTIN,
        UPDATE_EXISTING
      )
    end

    private

    def validate_config
      invalid = %w(api_key list_id).select { |m| send(m).nil? }
      fail Enquiry::ConfigError, "Missing config variables: #{invalid}" unless invalid.empty?
    end
  end
end
