require 'dm-timestamps'

class Correction
  include DataMapper::Resource

	# Relations
	belongs_to :solution

  # property <name>, <type>
  property :id, Serial
  property :public_comments, String
  property :private_comments, String
  property :grade, Float
	property :created_at, DateTime  
  property :updated_at, DateTime
  
end
