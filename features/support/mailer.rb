require 'mail'

module MailerHelper

  # It clears pool of email sent on :test 
  def self.clear
    Mail::TestMailer.deliveries.clear
  end

  # It returns the last email sent by App
  def self.last_email
    Mail::TestMailer.deliveries.pop
  end
end
