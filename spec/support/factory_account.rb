module Factories
  module Account
    def self.teacher(name = "Ra's al Ghul", email = "ras@d.com")
      params = {
        :name => name,
        :buid => name[0],
        :email => email,
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::TEACHER
      }
      Alfred::Admin::Account.find_by_email( email ) ||
                Alfred::Admin::Account.create( params )
    end

    def self.student(name = "Alfred", email = "al@d.com")
      params = {
        :name => name,
        :buid => name[0],
        :email => email,
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::STUDENT,
        :tag => 'mie'
      }
      Alfred::Admin::Account.find_by_email( email ) ||
                Alfred::Admin::Account.create( params )
    end

  end
end
