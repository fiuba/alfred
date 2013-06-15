# Helper methods defined here can be accessed in any controller or view in the application

Alfred::Admin.helpers do
  # Responses role list with localization support
  def roles_option_set 
    list = [] 
    Account.available_roles.each do |role| 
      # You can uncomment the line immediately below to enable localization
      # list << [ I18n.translate( "padrino.admin.roles.#{role}" ), role ]
      list << [ role, role ]
    end
    return list
  end
end
