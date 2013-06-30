require 'spec_helper'

describe AssignmentGenericFile do
	let(:course) { Course.create(:name => 'course 1') }
	let(:assignment) { Assignment.create(:name => 'assignment 1', :course => course) }

	it "should allow to set name" do
	  file = AssignmentGenericFile.new
	  
	  file.name = 'myfile'
	  file.name.should == 'myfile'
	end

	it "should return nil on name if path is not set" do
	  file = AssignmentGenericFile.new
		
		file.path.should be_nil
		file.name.should be_nil
	end

	it "should not raise error if nil is attempted to be assigned to name" do
	  file = AssignmentGenericFile.new

	  expect { file.name = nil }.not_to raise_error
	end

	# Validations are not working, need to look into this...
	it "should validate presence of path" do
	  file = AssignmentGenericFile.new

		file.path.should be_nil
		file.valid?.should be_false
		file.save.should be_false
	end

	it "should set definitive path on save" do
	  file = AssignmentGenericFile.new 

	  file.name = 'myFile'

	  file.path.should == "/assignments/temp/myfile"

	  file.assignment = assignment

	  file.save

	  file.path.should == "/assignments/#{assignment.id}/myfile"
	end

	it "should validate unique path" do
		file1 = AssignmentGenericFile.new
		file1.name = 'myFile'
		file1.save

		file2 = AssignmentGenericFile.new
		file2.name = 'myFile'

		file2.valid?.should be_false
		file2.save.should be_false
	end

	it "unique path validation should be case insensitive" do
	  file1 = AssignmentGenericFile.new
		file1.name = 'myFile'
		file1.save

		file2 = AssignmentGenericFile.new
		file2.name = 'MYFILE'

		file2.valid?.should be_false
		file2.save.should be_false
	end

	it "should not allow to change the name after set" do
	  file = AssignmentGenericFile.new
		file.name = 'myFile'

		expect { file.name = 'anotherFile' }.to raise_error(CannotUpdateNameError)
	end

	it "should not raise error if path is set twice with same value" do
	  file = AssignmentGenericFile.new
		file.name = 'myFile'

		expect { file.name = 'MYFILE' }.not_to raise_error(CannotUpdateNameError)
	end

	it "should delete physical file on destroy" do
	  
	end
end
