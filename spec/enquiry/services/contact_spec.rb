# require File.dirname(__FILE__) + '/../../spec_helper'
# require File.dirname(__FILE__) + '/../../../lib/enquiry/services/contact'

# describe ContactService do
#   context 'validating params' do
#     it 'fails validation with empty values' do
#       contact = ContactService.new(name: nil, email: '', demographic: nil)
#       expect(contact.valid?).to eq false
#     end

#     it 'fails validation with a rubbish email' do
#       contact = ContactService.new(name: Faker::Name.name, email: 'notareal3mail', demographic: 'student')
#       expect(contact.valid?).to eq false
#     end

#     it 'sets http status code 422 for invalid params' do
#       contact = ContactService.new(name: nil, email: 'notareal3mail', demographic: 'student')
#       expect(contact.valid?).to eq false
#       expect(contact.status_code).to eq 422
#     end
#   end

#   context 'saving' do
#     let(:contact) { ContactService.new 'name' => Faker::Name.name, 'email' => Faker::Internet.safe_email, 'demographic' => 'student' }
#     let(:contact_row) { [[:name, contact.name], [:email, contact.email], [:demographic, contact.demographic]] }
#     let(:mailchimp_params) { { 'NAME' => contact.name, 'DEMOGRAPH' => contact.demographic } }

#     before do
#       allow(ContactNotificationWorker).to receive(:perform_async)
#       allow(GoogleDriveWorker).to receive(:perform_async)
#       allow(MailchimpWorker).to receive(:perform_async)
#     end

#     it 'serializes to Google-Sheets-compatible data structure' do
#       expect(contact.to_row).to eq contact_row
#     end

#     it 'queues a job to add contact to Google Sheet' do
#       expect(GoogleDriveWorker).to receive(:perform_async).with(contact_row)
#       contact.save
#     end

#     # xit 'queues a job to add contact to Mailchimp list' do
#     #   expect(MailchimpWorker).to receive(:perform_async).with(contact.email, mailchimp_params)
#     #   contact.save
#     # end

#     it 'triggers a notification email' do
#       expect(ContactNotificationWorker).to receive(:perform_async)
#         .with('name' => contact.name, 'email' => contact.email, 'demographic' => contact.demographic)
#       contact.save
#     end
#   end
# end
