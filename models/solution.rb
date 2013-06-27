class Solution
  include DataMapper::Resource

	# Relations
	belongs_to :account
	belongs_to :assignment
	has 1, :correction
  has n, :solution_generic_files

  # property <name>, <type>
  property :id, Serial
  property :file, String

  validates_presence_of      :file

end
