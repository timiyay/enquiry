require 'spec_helper'
require 'enquiry/workers/google_drive'

describe Enquiry::GoogleDriveWorker do
  let(:drive_params) do
    {
      sheet_id: 'sheet-id',
      row: [
        [:name, Faker::Name.name],
        [:email, Faker::Internet.email]
      ]
    }
  end

  it 'performs a GoogleDriveService sheet edit' do
    expect(Enquiry::GoogleDriveService).to receive(:add_contact_to_sheet)
      .with(drive_params[:sheet_id], drive_params[:row])
    Enquiry::GoogleDriveWorker.new.perform(drive_params)
  end
end
