require 'dm-timestamps'

class Correction
  include DataMapper::Resource

	# Relations
	belongs_to :solution, :unique_index => :solution_teacher

  # Teacher who ranks
  belongs_to :teacher, :unique_index => :solution_teacher, :model => Account

  # property <name>, <type>
  property :id, Serial
  property :public_comments, String
  property :private_comments, String
  property :grade, Float
	property :created_at, DateTime  
  property :updated_at, DateTime

  validates_presence_of      :public_comments
  validates_presence_of      :private_comments

  validates_presence_of      :grade
  validates_numericality_of  :grade
  validates_within           :grade, :set => 0..10
  validates_with_method      :teacher, :is_a_teacher?

  validates_uniqueness_of    :solution, :scope => :teacher


  private
  def is_a_teacher? 
    if @teacher   
      return true if @teacher.is_teacher?
    end 

    return [ false, 'Only a teacher is able to correct' ]
  end
  
end
