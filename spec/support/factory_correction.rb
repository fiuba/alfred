module Factories
  module Correction
		def self.correctsBy( solution, teacher )
			Alfred::App::Correction.all.first ||
			Alfred::App::Correction.create( :teacher => teacher, :solution => solution )
		end
	end
end

