require 'securerandom'

migration 23, :create_alfred_user do
  up do
    user = Account.new
    user.buid = 'alfred'
    user.name = 'alfred'
    user.surname = 'alfred'
    user.email = 'alfred@algo3.com'
    user.role = Account::TEACHER
    password = SecureRandom.uuid
    user.password = password
    user.password_confirmation = password
    user.save
  end

  down do
    user = Account.create_alfred_user
    user.destroy unless user.nil?
  end
end
