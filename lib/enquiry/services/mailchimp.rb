require 'mailchimp'

# MailchimpService
#
# Provides a proxy to Mailchimp API actions, including:
#   - subscribing a contact to a Mailchimp list
class MailchimpService
  EMAIL_TYPE = 'html'
  DOUBLE_OPTIN = true
  UPDATE_EXISTING = true

  def self.add_contact_to_list(email, merge_params: {})
    MailchimpService.new(email, merge_params: merge_params).subscribe
  end

  def initialize(email, merge_params: {})
    @email = { email: email }
    @merge_params = merge_params
    validate_config
  end

  def subscribe
    Mailchimp::API.new(api_key).lists.subscribe list_id, @email, @merge_params, EMAIL_TYPE, DOUBLE_OPTIN, UPDATE_EXISTING
  end

  class ConfigError < StandardError; end

  private

  def api_key
    ENV['BRIDGEEDU_MAILCHIMP_API_KEY']
  end

  def list_id
    ENV['BRIDGEEDU_MAILCHIMP_LIST_ID']
  end

  def validate_config
    invalid = %w(api_key list_id).select { |m| send(m).nil? }
    fail ConfigError, "Missing config variables: #{invalid}" unless invalid.empty?
  end
end
