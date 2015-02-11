require 'spec_helper'
require 'enquiry/services/mailchimp'

describe Enquiry::MailchimpService do
  let(:api_key) { 'mailchimp-api-key' }
  let(:email) { Faker::Internet.email }
  let(:list_id) { 'mailchimp-list-id' }
  let(:merge_params) { { 'NAME' => Faker::Name.name, 'DEMOGRAPH' => 'student' } }

  context 'config validation' do
    it 'fails if Mailchimp API key is missing' do
      expect { Enquiry::MailchimpService.new(list_id, email, api_key: nil, merge_params: merge_params) }
        .to raise_error(Enquiry::ConfigError)
    end

    it 'fails if Mailchimp list id is missing' do
      expect { Enquiry::MailchimpService.new(nil, email, api_key: api_key, merge_params: merge_params) }
        .to raise_error(Enquiry::ConfigError)
    end
  end

  context '#subscribe' do
    it 'subscribes contact to mailing list' do
      mailchimp_api = instance_double Mailchimp::API
      allow(Mailchimp::API).to receive(:new).with(api_key).and_return(mailchimp_api)

      expect(mailchimp_api).to receive_message_chain(:lists, :subscribe)
        .with(
          # needs to match method signature of Mailchimp::API#lists.subscribe
          list_id,
          { email: email },
          merge_params,
          'html',                             # email type: text or html
          true,                               # send double opt-in email?
          true                                # update subscriber info, if already existing?
        )

      Enquiry::MailchimpService.add_contact_to_list(list_id, email, api_key: api_key, merge_params: merge_params)
    end
  end
end
