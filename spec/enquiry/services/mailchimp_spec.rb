# require_relative '../spec_helper'
# require_relative '../../services/contact'
# require_relative '../../services/mailchimp'

# xdescribe MailchimpService do
#   let(:contact) { ContactService.new name: Faker::Name.name, email: Faker::Internet.email, demographic: 'student' }

#   before do
#     ENV.update 'BRIDGEEDU_MAILCHIMP_API_KEY' => 'mailchimp-api-key', 'BRIDGEEDU_MAILCHIMP_LIST_ID' => 'mailchimp-list-id'
#   end

#   context 'config validation' do
#     it 'fails if Mailchimp API key is missing' do
#       ENV['BRIDGEEDU_MAILCHIMP_API_KEY'] = nil
#       expect { MailchimpService.new(contact.email, merge_params: contact.to_mailchimp) }.to raise_error(MailchimpService::ConfigError)
#     end

#     it 'fails if Mailchimp list id is missing' do
#       ENV['BRIDGEEDU_MAILCHIMP_LIST_ID'] = nil
#       expect { MailchimpService.new(contact.email, merge_params: contact.to_mailchimp) }.to raise_error(MailchimpService::ConfigError)
#     end
#   end

#   context '#subscribe' do
#     it 'subscribes contact to mailing list' do
#       # structure based on method signature of Mailchimp::API#lists.subscribe
#       subscription_args = [
#         ENV['BRIDGEEDU_MAILCHIMP_LIST_ID'],
#         { email: contact.email },
#         contact.to_mailchimp,
#         'html',                             # email type: text or html
#         true,                               # send double opt-in email?
#         true                                # update subscriber info, if already existing?
#       ]

#       mailchimp_api = instance_double Mailchimp::API
#       allow(Mailchimp::API).to receive(:new).and_return(mailchimp_api)
#       expect(mailchimp_api).to receive_message_chain(:lists, subscribe: subscription_args)
#       MailchimpService.add_contact_to_list(contact.email, merge_params: contact.to_mailchimp)
#     end
#   end
# end
