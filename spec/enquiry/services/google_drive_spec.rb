require 'spec_helper'
require 'enquiry/services/google_drive'

# Make certain privileged methods and attributes public, for testing purposes
class GoogleDriveService
  public :access_token, :refresh_access_token, :refresh_token
end

describe GoogleDriveService do
  let(:client_id) { 'client-id' }
  let(:client_secret) { 'client-secret' }
  let(:drive_api) { GoogleDriveService.new(sheet_id, row, client_id: client_id, client_secret: client_secret, store: store) }
  let(:row) { [[:name, Faker::Name.name], [:email, Faker::Internet.email]] }
  let(:session) { instance_double(GoogleDrive::Session) }
  let(:sheet) { instance_spy(GoogleDrive::Spreadsheet) }
  let(:sheet_id) { 'sheet-id' }
  let(:store) { instance_spy StorageService }

  context 'config validation' do
    it 'fails if OAuth2 client id is missing' do
      expect { GoogleDriveService.new(sheet_id, row, client_id: nil, client_secret: client_secret) }.to raise_error(GoogleDriveService::ConfigError)
    end

    it 'fails if OAuth2 client secret is missing' do
      expect { GoogleDriveService.new(sheet_id, row, client_id: client_id, client_secret: nil) }.to raise_error(GoogleDriveService::ConfigError)
    end

    it 'fails if Google Sheet document id is missing' do
      expect { GoogleDriveService.new(nil, row, client_id: client_id, client_secret: client_secret) }.to raise_error(GoogleDriveService::ConfigError)
    end
  end

  context 'authenticating with Drive API' do
    let(:access_token) { 'drive-api-access-token' }

    before do
      allow(store).to receive(:get).with('ENQUIRY_GDRIVE_ACCESS_TOKEN').and_return(access_token)
    end

    it 'loads stored access token' do
      expect(store).to receive(:get).with('ENQUIRY_GDRIVE_ACCESS_TOKEN').and_return(access_token)
      expect(drive_api.access_token).to eq access_token
    end

    context 'when access token is expired' do
      let(:api_client) { instance_double Google::APIClient, authorization: auth_client }
      let(:auth_client) { instance_spy Signet::OAuth2::Client, access_token: new_access_token }
      let(:new_access_token) { 'new-drive-api-access-token' }
      let(:refresh_token) { 'drive-api-refresh-token' }

      before do
        allow(store).to receive(:get).with('ENQUIRY_GDRIVE_REFRESH_TOKEN').and_return(refresh_token)
        allow(Google::APIClient).to receive(:new).and_return(api_client)
      end

      it 'loads stored refresh token' do
        expect(drive_api.refresh_token).to eq refresh_token
      end

      it 'requests a new access token, using refresh token' do
        expect(drive_api.access_token).to_not eq new_access_token
        drive_api.refresh_access_token
        expect(drive_api.access_token).to eq new_access_token
        expect(auth_client).to have_received(:refresh_token=).with(refresh_token)
        expect(auth_client).to have_received(:fetch_access_token!)
      end

      it 'stores new access token' do
        drive_api.refresh_access_token
        expect(store).to have_received(:set).with('ENQUIRY_GDRIVE_ACCESS_TOKEN', new_access_token)
      end

      it 'raises error if API rejects token request' do
        allow(auth_client).to receive(:fetch_access_token!).and_raise(Signet::AuthorizationError.new 'message', {})
        expect { drive_api.refresh_access_token }.to raise_error(GoogleDriveService::OAuth2Error)
      end
    end
  end

  context 'editing sheet' do
    before do
      allow(GoogleDrive).to receive(:login_with_oauth).and_return(session)
      allow(session).to receive(:spreadsheet_by_key).and_return(sheet)
      allow(sheet).to receive_message_chain('worksheets.first.list.push')
      allow(sheet).to receive_message_chain('worksheets.first.save')
      drive_api.ensure_session
    end

    it 'adds a new row with contact info' do
      expect(sheet).to receive_message_chain('worksheets.first.list.push').with(row)
      drive_api.add_contact_to_sheet
    end

    it 'saves changes to Drive API' do
      expect(sheet).to receive_message_chain('worksheets.first.save')
      drive_api.add_contact_to_sheet
    end
  end
end
