require 'sidekiq/testing'
require 'enquiry/workers/email_notification'

Sidekiq::Testing.inline!

describe Enquiry::EmailNotificationWorker do
end
