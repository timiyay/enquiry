require 'google/api_client'
require 'google_drive'

require 'enquiry/errors'
require 'enquiry/services/storage'

module Enquiry
  # GoogleDriveService
  #
  # Provides a proxy to Google Drive API actions, including:
  #   - authenticating via OAuth2 access and refresh tokens
  #   - saving data to a Google Sheet document
  class GoogleDriveService
    attr_accessor :client_id, :client_secret, :sheet_id

    def self.add_contact_to_sheet(sheet_id, row, client_id: nil, client_secret: nil, store: nil)
      GoogleDriveService.new(
        sheet_id,
        row,
        client_id: client_id,
        client_secret: client_secret,
        store: store
      ).add_contact_to_sheet
    end

    def initialize(sheet_id, row, client_id: nil, client_secret: nil, store: nil)
      @client_id = client_id || ENV['ENQUIRY_GDRIVE_CLIENT_ID']
      @client_secret = client_secret || ENV['ENQUIRY_GDRIVE_CLIENT_SECRET']
      @row = row
      @session = nil
      @sheet = nil
      @sheet_id = sheet_id || ENV['ENQUIRY_GDRIVE_SHEET_ID']
      @store = store || Enquiry::StorageService.new

      # Stash these attrs in pseudo-private variables, as we'll be using
      # custom getter / setter methods to access them
      @_access_token = nil
      @_refresh_token = nil

      validate_config
    end

    def add_contact_to_sheet
      ensure_session
      worksheet = @sheet.worksheets.first
      worksheet.list.push @row
      worksheet.save
    end

    def ensure_session
      # decided the most-efficient way to check token validity was to
      # request the sheet we want, and refresh the token if that fails.
      # If the sheet request fails a 2nd time, then we're assuming it's
      # a fatal error the app can't recover from, like network or Google Drive
      # outages, or needed a new OAuth2 authorization code (a manual process)
      retries ||= 1
      start_session
      sheet
    rescue Google::APIClient::AuthorizationError
      # basic retry of access token request
      # planning to refactor to use retriable library
      refresh_access_token
      retries -= 1
      retry if retries >= 0
    rescue Google::APIClient::ClientError => e
      if e.message.downcase == 'insufficient permission'
        raise Enquiry::ConfigError, 'Google Drive API says we have insufficient permission to access the specified sheet ID.'
      end
      raise e
    end

    private

    def access_token
      @_access_token ||= @store.get('ENQUIRY_GDRIVE_ACCESS_TOKEN') || 'no-access-token-available'
    end

    def access_token=(token)
      @store.set 'ENQUIRY_GDRIVE_ACCESS_TOKEN', token
      @_access_token = token
    end

    def authorization
      client = Google::APIClient.new
      auth = client.authorization
      auth.client_id = client_id
      auth.client_secret = client_secret
      auth.scope = authorization_scope
      auth.redirect_uri = redirect_uri
      auth
    end

    def authorization_scope
      'https://www.googleapis.com/auth/drive'
    end

    def redirect_uri
      'urn:ietf:wg:oauth:2.0:oob'
    end

    def refresh_access_token
      fail Enquiry::OAuth2Error, 'No refresh token available.' if refresh_token.nil?
      auth = authorization
      auth.refresh_token = refresh_token
      auth.fetch_access_token!
      self.access_token = auth.access_token
    rescue Signet::AuthorizationError
      message = 'Could not get new access token from Google, using current refresh token. You may need ' \
                'to reauthorize the app for Google Drive API access, and save the new refresh token.'
      raise Enquiry::OAuth2Error, message
    end

    def refresh_token
      @_refresh_token ||= @store.get 'ENQUIRY_GDRIVE_REFRESH_TOKEN'
    end

    def sheet
      @sheet ||= @session.spreadsheet_by_key sheet_id
    end

    def start_session
      @session ||= GoogleDrive.login_with_oauth(access_token)
    end

    def validate_config
      invalid = %w(authorization_scope client_id client_secret redirect_uri sheet_id).select { |m| send(m).nil? }
      fail Enquiry::ConfigError, "Missing config variables: #{invalid}" unless invalid.empty?
    end
  end
end
