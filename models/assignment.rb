class Assignment
  include DataMapper::Resource

  belongs_to :course
  has n, :assignment_generic_files

  property :id, Serial
  property :name, String
  property :test_script, String
  property :deadline, DateTime
end
