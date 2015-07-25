module Factories
  module Correction
		def self.corrects_by( solution, teacher )
			Alfred::App::Correction.create( :created_at => Date.today,
        :grade => 7, :teacher => teacher, :solution => solution )
		end
	end
end

