module Factories
  module Assignment
    def self.vending_machine
	    course = Alfred::Admin::Course.find(:name => 'course 1') || Alfred::Admin::Course.create(:name => 'course 1')
      Alfred::Admin::Assignment.create(:name => 'Vending Machine', :course => course)
    end

    def self.withSolution
      assignment = vending_machine
	    solution = Factories::Solution.for(assignment)
	    assignment.save!

      assignment
    end
  end
end

