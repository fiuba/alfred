module Factories
  module Solution
    def self.for( assignment)

      author = Factories::Account.student
      file_name = 'solution.st'

      new_solution = Alfred::App::Solution.create!( 
        :file => file_name, :account => author,
        :created_at => DateTime.now,
        :assignment => assignment )

			Alfred::App::SolutionGenericFile.create!( 
        :solution => new_solution, :name => file_name )

      new_solution
    end

    def self.forBy( assignment, account = nil)
      author = account || Factories::Account.student
      file_name = 'solution.st'

      new_solution = Alfred::App::Solution.create!( 
        :file => file_name, :account => author,
        :created_at => DateTime.now,
        :assignment => assignment )

			Alfred::App::SolutionGenericFile.create!( 
        :solution => new_solution, :name => file_name )

      new_solution
    end
  end
end

