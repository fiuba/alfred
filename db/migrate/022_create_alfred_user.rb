migration 22, :create_alfred_user do
  up do
    user = Account.new
    user.buid = 'alfred'
    user.name = 'alfred'
    user.surname = 'alfred'
    user.email = 'alfred@algo3.com'
    user.role = Account::TEACHER
    user.password = 'Passw0rd!'
    user.password_confirmation = 'Passw0rd!'
    user.save
  end

  down do
    user = Account.create_alfred_user
    user.destroy unless user.nil?
  end
end
