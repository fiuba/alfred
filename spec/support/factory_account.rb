module Factories
  module Account
    def self.teacher(name = "Ra's al Ghul", surname = "", email = "ras@d.com")
      params = {
        :name => name,
        :surname => surname,
        :buid => name[0],
        :email => email,
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::TEACHER
      }
      Alfred::Admin::Account.find_by_email( email ) ||
                Alfred::Admin::Account.create( params )
    end

    def self.student(name = "Alfred", surname = "Hetcher", email = "al@d.com", buid = "A" )
      params = {
        :name => name,
        :surname => surname,
        :buid => buid,
        :email => email,
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::STUDENT,
        :tag => 'mie'
      }
      account = Alfred::Admin::Account.find_by_email( email ) ||
                Alfred::Admin::Account.create( params )
      account.courses << Factories::Course.algorithm
      account.save
      account
    end

    def self.me_as_student
      self.student("MyName", "Surname", "me@student.com", "77789")
    end

    def self.me_as_teacher
      self.teacher("AnotherName", "AnotherSurname", "me@teacher.com")
    end

  end
end
