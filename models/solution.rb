require 'dm-constraints'

class Solution
  include DataMapper::Resource

	# Relations
	belongs_to :account
	belongs_to :assignment
	has 1, :correction
  has n, :solution_generic_files, :constraint => :destroy

  # property <name>, <type>
  property :id, Serial
  property :file, String
  property :link, String
  property :comments, String
  property :created_at, DateTime 
  property :test_result, String, :default => 'not_available' # other possible results are 'passed' and 'failed'
  property :test_output, String 

  def self.latest_by_student_and_assignment(student, assignment)
    solutions = self.get_by_student_and_assignment(student, assignment)
    solutions.sort_by! { |s| s.created_at}
    solutions.last
  end

  def self.get_by_student_and_assignment(student, assignment)
    Solution.all(:account => student, :assignment => assignment)
  end

  def is_author?( account )
    self.account == account
  end 

  def register_test_result(result, output)
    self.test_result = result
    self.test_output = output
    if (self.assignment.is_optional)
      correction =  Correction.new
      correction.solution = self
      correction.teacher = Account.alfred_user
      correction.grade = Correction.default_grade
      correction.save
    end
  end

end
