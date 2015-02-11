require 'spec_helper'
require 'enquiry/workers/email_notification'

describe Enquiry::EmailNotificationWorker do
  let(:worker_params) do
    {
      to: Faker::Internet.safe_email,
      from: Faker::Internet.safe_email,
      subject: Faker::Company.bs,
      body: Faker::Company.catch_phrase,
      provider: {
        method: :smtp,
        address: "smtp.#{Faker::Internet.domain_name}",
        port: '587',
        user_name: Faker::Internet.user_name,
        password: Faker::Internet.password,
        authentication: :plain,
        domain: Faker::Internet.domain_name
      }
    }
  end

  it 'performs an EmailNotificationService delivery' do
    expect(Enquiry::EmailNotificationService).to receive(:deliver)
      .with(
        to: worker_params[:to],
        from: worker_params[:from],
        subject: worker_params[:subject],
        body: worker_params[:body],
        provider: worker_params[:provider]
      )
    Enquiry::EmailNotificationWorker.new.perform(worker_params)
  end
end
