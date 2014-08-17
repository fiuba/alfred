module Factories
  module Assignment
    def self.name( name = "TP 0", course = nil )
	    course ||=  \
        Alfred::Admin::Course.find(:name => 'course 1') || \
        Alfred::Admin::Course.create(:name => 'course 1')
        
        assignment = Alfred::Admin::Assignment.new()
        assignment.name = name
        assignment.course = course
        assignment.save
        assignment
    end

    def self.vending_machine
      self.name( 'Vending Machine' )
    end

    def self.withSolution
      assignment = vending_machine
	    solution = Factories::Solution.for(assignment)
	    assignment.save!

      assignment
    end
  end
end

