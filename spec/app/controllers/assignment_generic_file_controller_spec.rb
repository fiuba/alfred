require 'spec_helper'

describe "AssignmentGenericFileController" do
  it "should return all files for assignment on index" do
  	assignment_id = 1234
  	assignment = double(Assignment, :id => assignment_id)
  	assignment.should_receive(:assignment_generic_files).and_return([])
		Assignment.should_receive(:find).with('1234').and_return(assignment)
		course_double = double(:id => 202)
		Course.should_receive(:first).any_number_of_times.and_return(course_double)

		get "/assignment/#{assignment_id}/assignment_generic_file"
	end

	it "should destroy AssignmentGenericFile and delete file from storage" do
		assignment_file = double(AssignmentGenericFile, :path => '/my_files/99')
		AssignmentGenericFile.should_receive(:get).with(99).and_return(assignment_file)
		transaction_double = double
		assignment_file.should_receive(:transaction).and_yield(transaction_double)
		assignment_file.should_receive(:destroy).and_return(true)
		storage_gateway_double = double(Storage::DropboxGateway)
		storage_gateway_double.should_receive(:delete).with('/my_files/99').and_return(true)
		Storage::StorageGateways.should_receive(:get_gateway).and_return(storage_gateway_double)

	  delete "/assignment/1234/assignment_generic_file/destroy/99"
	end

	it "should not delete physical file if DB record fails to be deleted" do
	  assignment_file = double(AssignmentGenericFile, :path => '/my_files/99')
		AssignmentGenericFile.should_receive(:get).with(99).and_return(assignment_file)
		transaction_double = double
		assignment_file.should_receive(:transaction).and_yield(transaction_double)
		assignment_file.should_receive(:destroy).and_return(false)
		Storage::StorageGateways.should_not_receive(:get_gateway)

	  delete "/assignment/1234/assignment_generic_file/destroy/99"
	end

	it "should rollback transaction if physical file deletion fails" do
	  assignment_file = double(AssignmentGenericFile, :path => '/my_files/99')
		AssignmentGenericFile.should_receive(:get).with(99).and_return(assignment_file)
		transaction_double = double
		transaction_double.should_receive(:rollback)
		assignment_file.should_receive(:transaction).and_yield(transaction_double)
		assignment_file.should_receive(:destroy).and_return(true)
		storage_gateway_double = double(Storage::DropboxGateway)
		storage_gateway_double.should_receive(:delete).with('/my_files/99').and_raise(Storage::FileDeleteError.new(double(DropboxError, :message => 'Cannot delete file')))
		Storage::StorageGateways.should_receive(:get_gateway).and_return(storage_gateway_double)

	  delete "/assignment/1234/assignment_generic_file/destroy/99"
	end
end
