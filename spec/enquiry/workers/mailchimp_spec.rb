require 'spec_helper'
require 'enquiry/workers/mailchimp'

describe Enquiry::MailchimpWorker do
  let(:mailchimp_params) do
    {
      list_id: 'mailchimp-list-id',
      email: Faker::Internet.email,
      merge_params: { 'NAME' => Faker::Name.name, 'DEMOGRAPH' => 'student' }
    }
  end

  it 'performs a MailchimpService subscription' do
    expect(Enquiry::MailchimpService).to receive(:add_contact_to_list)
      .with(
        mailchimp_params[:list_id],
        mailchimp_params[:email],
        merge_params: mailchimp_params[:merge_params]
      )
    Enquiry::MailchimpWorker.new.perform(mailchimp_params)
  end
end
