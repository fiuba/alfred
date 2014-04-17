module Factories
  module Course
    def self.name( name = "algorithm" )
      Alfred::App::Course.find_by_name( name ) ||
        Alfred::App::Course.create( :name => name, :active => true )
    end 

    def self.algorithm
      self.name( "algorithm" )
    end
  end
end

