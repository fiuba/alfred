# It's intended to centralize reading of environmental variables 
# related with mail notification configuration
#
# List of variables:
#
# - MAIL_PREVENT_NOTIFICATION_FOR: 
#   * If is set to 'test_result', Alfred is not sending test_result notification to students
#
class MailNotifierConfig

  def self.has_to_prevent_notification_for( action )
    stored_values(ENV['MAIL_PREVENT_NOTIFICATION_FOR']).include?( action )
  end

  private

  VARIABLE_SEPARATOR = ','

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
