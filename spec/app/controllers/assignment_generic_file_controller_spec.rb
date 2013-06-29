require 'spec_helper'

describe "AssignmentGenericFileController" do
  it "should return all files for assignment on index" do
  	assignment_id = 1234
  	assignment = double(Assignment, :id => assignment_id)
  	assignment.should_receive(:assignment_generic_files).and_return([])
		Assignment.should_receive(:find).with('1234').and_return(assignment)

		get "/assignment/#{assignment_id}/assignment_generic_file"
	end

	# TODO: Review test! Request is not being processed
	xit "should destroy AssignmentGenericFile and delete file from storage" do
		assignment_file = double(AssignmentGenericFile, :path => '/my_files/99')
		AssignmentGenericFile.should_receive(:get).with(99).and_return(assignment_file)
		gateway = double(Storage::DropboxGateway)
		gateway.should_receive(:delete).with('/my_files/99')
		Storage::StorageGateways.should_receive(:get_gateway).and_return(gateway)

	  delete "/assignment/1234/assignment_generic_file/destroy/99"
	end
end
