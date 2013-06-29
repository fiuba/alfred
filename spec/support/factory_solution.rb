module Factories
  module Solution
    def self.for( anAssignment )
      account = Factories::Account.student
      file_name = 'solution.st'
      Alfred::App::Solution.create( 
        :file => file_name,
        :account => account,
        :assignment => anAssignment
      )
    end
  end
end

