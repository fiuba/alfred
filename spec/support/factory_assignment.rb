module Factories
  module Assignment
    def self.name( name = "TP 0", course = nil )
	    course ||=  \
        Alfred::Admin::Course.find(:name => 'course 1') || \
        Alfred::Admin::Course.create(:name => 'course 1')
      Alfred::Admin::Assignment.create(:name => name, :course => course)
    end

    def self.vending_machine
      self.name( 'Vending Machine' )
    end

    def self.tp( name = 'TP 0' )
      Alfred::Admin::Assignment.create(:course => Factories::Course.algorithm, \
        :name => name )
    end

    def self.withSolution
      assignment = vending_machine
	    solution = Factories::Solution.for(assignment)
	    assignment.save!

      assignment
    end
  end
end

