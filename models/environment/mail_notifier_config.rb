# It's intended to centralize reading of environmental variables 
# related with mail notification configuration
#
# List of variables:
#
# - MAIL_PREVENT_NOTIFICATION_FOR: 
#   * If is set to 'test_result', Alfred is not sending test_result notification to students
#
class MailNotifierConfig

  VARIABLE_SEPARATOR = ','

  def self.has_to_send_notification_of_test_result
    not stored_values(ENV['MAIL_PREVENT_NOTIFICATION_FOR']).include?(:test_result)
  end

  def self.stored_values( content )
    value =  content || ""
    value.split(VARIABLE_SEPARATOR).collect do |value| 
      begin
        value.to_sym
      rescue
        ''
      end
    end
  end

  
end
