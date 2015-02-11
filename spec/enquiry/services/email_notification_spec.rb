require 'spec_helper'
require 'enquiry/services/email_notification'

describe EmailNotificationService do
  let(:email_body) { Faker::Company.catch_phrase }
  let(:email_subject) { Faker::Company.bs }
  let(:mailer) { class_double Pony }
  let(:recipient) { Faker::Internet.safe_email }
  let(:sender) { Faker::Internet.safe_email }

  let(:email_config) do
    {
      method: :smtp,
      address: "smtp.#{Faker::Internet.domain_name}",
      port: '587',
      user_name: Faker::Internet.user_name,
      password: Faker::Internet.password,
      authentication: :plain,
      domain: Faker::Internet.domain_name
    }
  end

  before do
    allow(Pony).to receive(:mail)
  end

  context '#deliver' do
    subject do
      EmailNotificationService.deliver(
        to: recipient,
        from: sender,
        subject: email_subject,
        body: email_body,
        provider: email_config
      )
    end
    it 'sets the recipient and sender addresses' do
      expect(Pony).to receive(:mail).with(hash_including(to: recipient, from: sender))
      subject
    end

    it 'sets the subject' do
      expect(Pony).to receive(:mail).with(hash_including(subject: email_subject))
      subject
    end

    it 'constructs the message body, filling in any attrs' do
      expect(Pony).to receive(:mail).with(hash_including(body: email_body))
      subject
    end

    it 'uses the provided email config options' do
      expected_method = email_config[:method]
      expected_config = email_config.tap { |c| c.dup.delete(:method) }
      expect(Pony).to receive(:mail).with(hash_including(via: expected_method, via_options: expected_config))
      subject
    end

    it "raises an error if required params aren't provided" do
      required_params = %w(to from address password user_name)
      expect { EmailNotificationService.deliver }.to raise_error(EmailNotificationService::ConfigError) do |error|
        required_params.each { |v| expect(error.message).to include(v) }
      end
    end
  end
end
