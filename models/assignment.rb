class Assignment
  include DataMapper::Resource

  belongs_to :course
  has n, :assignment_files
  has n, :solutions, :constraint => :protect

  property :id, Serial
  property :name, String
  property :test_script, Text
  property :deadline, DateTime

  def self.find_by_course (course)
  	Assignment.all(:course => course)
  end
end
