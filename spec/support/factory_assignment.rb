module Factories
  module Assignment
    def self.vending_machine
	    course = Alfred::Admin::Course.create(:name => 'course 1')
      Alfred::Admin::Assignment.create(:name => 'Vending Machine', :course => course)
    end
  end
end

