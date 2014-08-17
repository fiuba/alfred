class Assignment
  include DataMapper::Resource

  belongs_to :course
  has 1, :assignment_file
  has n, :solutions, :constraint => :protect

  property :id, Serial
  property :name, String
  property :test_script, Text
  property :deadline, DateTime
  property :is_auto_grading, Boolean, :default => false

  def self.find_by_course (course)
  	Assignment.all(:course => course)
  end
end
