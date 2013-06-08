class Solution
  include DataMapper::Resource

	# Relations
	belongs_to :account
	belongs_to :assignment

  # property <name>, <type>
  property :id, Serial
  property :file, String

  validates_presence_of      :file

end
