class Course
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :active, Boolean
  has n, :accounts, :through => Resource

  before :save do
    # Allow a single course to be active
    if self.active
      Course.each { |c| c.update(active: false) if c != self  }
    else
      self.active = true if !Course.any? { |c| c.active }
    end
  end

  def self.active
  	Course.find_by_active(true)
  end

  def students
  	self.accounts.select { |a| a.is_student? }
  end
end
