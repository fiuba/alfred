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
	property :created_at, DateTime  
  property :updated_at, DateTime

	property :solution_id, 	Integer, 
		:required => true, :unique => :solution

  validates_within        :grade, :set => (0..10).to_a << nil
  validates_with_method   :teacher, :is_a_teacher?
  validates_present       :teacher
  validates_present       :solution

  def approved?
    self.grade && self.grade >= 4
  end

  private
  def is_a_teacher? 
    if @teacher   
      return true if @teacher.is_teacher?
    end 

    return [ false, 'Only a teacher is able to correct' ]
  end
  
end
