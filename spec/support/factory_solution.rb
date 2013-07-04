module Factories
  module Solution
    def self.for( anAssignment )
      account = Factories::Account.student
      file_name = 'solution.st'

      new_solution = Alfred::App::Solution.create!( 
        :file => file_name, :account => account,
        :assignment => anAssignment )

			Alfred::App::SolutionGenericFile.create!( 
        :solution => new_solution, :name => file_name )

      new_solution
    end
  end
end

