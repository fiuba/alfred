module Factories
  module Correction

		def self.corrects_by(solution, teacher)
			corrects_by_with_grade(solution, teacher, 7)
		end

		def self.corrects_by_with_grade(solution, teacher, grade)
			Alfred::App::Correction.create( :created_at => Date.today,
																			:grade => grade, :teacher => teacher, :solution => solution )
		end

	end
end

