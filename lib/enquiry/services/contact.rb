require 'pony'

require_relative '../workers/contact_notification'
require_relative '../workers/google_drive'
require_relative '../workers/mailchimp'

# ContactService
#
# Provides a proxy to services required for handling contact form submission, including:
#   - validating the submitted form attributes
#   - notifying the site owner of the form submission, via email
#   - adding contact info to a Google Sheet document
#   - adding contact info to a Mailchimp mailing list
class ContactService
  attr_reader :name, :email, :demographic, :status_code

  def initialize(contact_params)
    parse_params(contact_params)
    @status_code = valid? ? 200 : 422
  end

  def save
    return unless valid?
    GoogleDriveWorker.perform_async(to_row)
    # MailchimpWorker.perform_async(@email, to_mailchimp)
    ContactNotificationWorker.perform_async('name' => @name, 'email' => @email, 'demographic' => @demographic)
  end

  def send_notification_email
    body = %(
      Somebody just signed up for your latest updates on bridgeedu.com!

      name: #{@name}
      email: #{@email}
      demographic: #{@demographic}
    )

    Pony.mail to: ENV['BRIDGEEDU_SIGNUP_RECIPIENT_EMAIL'],
              from: 'signup@bridgeedu.com',
              subject: 'New signup for BridgeEdu',
              body: body,
              via: :smtp,
              via_options: {
                address: 'smtp.mandrillapp.com',
                port: '587',
                user_name: ENV['MANDRILL_USERNAME'],
                password: ENV['MANDRILL_APIKEY'],
                authentication: :plain,
                domain: 'heroku.com'
              }
  end

  def to_mailchimp
    # email is not included, as the Mailchimp API expects it in
    # a separate param. The email is directly passed into our
    # Mailchimp service method, elsewhere
    { 'NAME' => @name, 'DEMOGRAPH' => @demographic }
  end

  def to_row
    [[:name, @name], [:email, @email], [:demographic, @demographic]]
  end

  def valid?
    is_valid = [@name, @email, @demographic].map { |param| !param.nil? && !param.empty? }
    is_valid << validate_email(@email)
    is_valid.all?
  end

  private

  def parse_params(contact_params)
    if contact_params.respond_to? :values_at
      @name, @email, @demographic = contact_params.values_at 'name', 'email', 'demographic'
    else
      @name, @email, @demographic = nil
    end
  end

  def validate_email(email)
    # 'rough enough' email address regex borrowed from Stack Overflow
    # http://stackoverflow.com/a/742588
    /^[^@]+@[^@]+\.[^@]+$/.match(email)
  end
end
