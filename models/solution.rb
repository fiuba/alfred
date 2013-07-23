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
  property :test_result, String, :default => 'not_available'
  property :test_output, String 

  validates_presence_of      :file

end
