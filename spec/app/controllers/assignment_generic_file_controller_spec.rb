require 'spec_helper'

describe "AssignmentGenericFileController" do
  it "should return all files for assignment on index" do
  	assignment_id = 1234
  	assignment = double(Assignment, :id => assignment_id)
  	assignment.should_receive(:assignment_generic_files).and_return([])
		Assignment.should_receive(:find).with('1234').and_return(assignment)

		get "/assignment/#{assignment_id}/assignment_generic_file"
	end

	it "should destroy AssignmentGenericFile and delete file from storage" do
		assignment_file = double(AssignmentGenericFile, :path => '/my_files/99')
		AssignmentGenericFile.should_receive(:get).with(99).and_return(assignment_file)
		assignment_file.should_receive(:destroy)

	  delete "/assignment/1234/assignment_generic_file/destroy/99"
	end
end
