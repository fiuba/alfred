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
  property :teacher_id, Integer
  property :solution_id, Integer, :required => true, :unique => :solution
	property :created_at, DateTime  
  property :updated_at, DateTime
	property :solution_id, 	Integer, 
		:required => true, :unique => :solution

  validates_presence_of      :solution
  validates_presence_of      :teacher
  validates_within        :grade, :set => (0..10).to_a << nil
  validates_with_method   :teacher, :is_a_teacher?
  validates_present       :teacher
  validates_present       :solution

  def approved?
    self.grade && self.grade >= 4
  end

  def self.create_for_teacher(teacher, student, assignment)
    latest = Solution.latest_by_student_and_assignment(student,assignment)
    raise I18n.t('corrections.no_solutions_found') if latest.nil?
    raise I18n.t('corrections.solution_already_assigned') if !latest.correction.nil?
    Correction.create!(:solution => latest, :teacher => teacher)
  end

  def status
    if grade.nil? 
      :correction_in_progress
    elsif approved?
      :correction_passed
    else
      :correction_failed
    end
  end

  private
  def is_a_teacher? 
    if @teacher   
      return true if @teacher.is_teacher?
    end 

    return [ false, 'Only a teacher is able to correct' ]
  end
  
end
