class Course
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :active, Boolean
end
