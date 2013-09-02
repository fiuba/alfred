module Factories
  module Correction
		def self.correctsBy( solution, teacher )
			Alfred::App::Correction.create( :created_at => Date.today,
        :grade => 7, :teacher => teacher, :solution => solution )
		end
	end
end

