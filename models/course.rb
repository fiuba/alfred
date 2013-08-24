class Course
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :active, Boolean
  has n, :accounts, :through => Resource

  def self.active
  	Course.find_by_active(true)
  end
  
  def students
  	self.accounts.select { |a| a.is_student? }
  end
end
