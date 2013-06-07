class Assignment
  include DataMapper::Resource

  belongs_to :course

  property :id, Serial
  property :name, String
  property :files, String
  property :test_script, String
  property :deadline, DateTime
end
