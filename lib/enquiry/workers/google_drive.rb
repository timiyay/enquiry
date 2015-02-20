require 'sidekiq'
require 'enquiry/services/google_drive'

module Enquiry
  class GoogleDriveWorker
    include Sidekiq::Worker

    def perform(drive_params)
      drive_params = Enquiry::Utils.symbolize_keys(drive_params)
      GoogleDriveService.add_contact_to_sheet(drive_params[:sheet_id], drive_params[:row])
    end
  end
end
