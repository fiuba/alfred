module Factories
  module Account
    def self.student(name = "Alfred", email = "al@d.com")
      params = {
        :name => name,
        :buid => 'Al',
        :email => email,
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::STUDENT
      }
      Alfred::Admin::Account.create!( params )
    end
  end
end
