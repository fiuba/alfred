module Factories
  module Account
    def self.student
      params = {
        :name => 'Alfred',
        :buid => 'Al',
        :email => 'al@d.com',
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::STUDENT
      }
      Alfred::Admin::Account.create( params )
    end
  end
end
