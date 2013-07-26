require 'dm-timestamps'

class Correction
  include DataMapper::Resource

	# Relations
	belongs_to :solution

  # Teacher who ranks
  belongs_to :teacher, :model => Account


  # property <name>, <type>
  property :id, Serial
  property :public_comments, String
  property :private_comments, String
  property :grade, Float
  property :teacher_id, Integer, :unique_index => :solution_teacher
  property :solution_id, Integer, :required => true, :unique => :solution
	property :created_at, DateTime  
  property :updated_at, DateTime

  validates_presence_of      :solution
  validates_presence_of      :teacher

  validates_within           :grade, :set => (0..10).to_a << nil
  validates_with_method      :teacher, :is_a_teacher?
  validates_uniqueness_of    :solution, :scope => :teacher

  def approved?
    self.grade && self.grade >= 4
  end

  def self.create_for_teacher(teacher, student, assignment)
    solutions = Solution.find_by_account_and_assignment(student, assignment, :order => [ :created_at.desc ]) || []
    if !solutions.respond_to?(:count)
      solutions = [ solutions ]
    end
    raise I18n.t('corrections.no_solutions_found') if solutions.empty?
    latest_solution = solutions.first
    raise I18n.t('corrections.solution_already_assigned') if !latest_solution.correction.nil?

    Correction.create!(:solution => latest_solution, :teacher => teacher)
  end

  def status
    grade.nil? ? :in_progress : :completed
  end

  private
  def is_a_teacher? 
    if @teacher   
      return true if @teacher.is_teacher?
    end 

    return [ false, 'Only a teacher is able to correct' ]
  end
  
end
