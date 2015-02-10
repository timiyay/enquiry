require 'sidekiq'
require_relative '../services/google_drive'

class GoogleDriveWorker
  include Sidekiq::Worker

  def perform(contact)
    GoogleDriveService.add_contact_to_sheet(contact)
  end
end
