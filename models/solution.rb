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
  property :created_at, DateTime 
  property :test_result, String, :default => 'not_available' # other possible results are 'passed' and 'failed'
  property :test_output, String 

  validates_presence_of      :file

  def self.get_by_student_and_assignment(student, assigment)
    Solution.all(:account => student, :assignment => assignment)
  end

  def is_author?( account )
    self.account == account
  end 

end
