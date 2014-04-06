require 'dm-constraints'

class Karma
  include DataMapper::Resource

	# Relations
	belongs_to :student, :model => Account
	belongs_to :course

  # property <name>, <type>
  property :id, Serial
  property :description, String
  property :value, Integer
  property :created_at, DateTime 

  validates_presence_of      :value

  def self.for_student_in_course(student, course)
    karma = Karma.new
    karma.student = student
    karma.course = course
    karma.value = 1
    karma
  end

  def self.count_for_student_in_course(student, course)
    Karma.count(:student => student, :course => course)
  end

end
