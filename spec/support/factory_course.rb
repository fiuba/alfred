module Factories
  module Course
    def self.algorithm
      name = "algorithm"
      Alfred::App::Course.find_by_name( name ) ||
        Alfred::App::Course.create( :name => name, :active => true )
    end
  end
end

