require 'spec_helper'

describe SolutionGenericFile do
  before (:each) do
    DataMapper.auto_migrate!
  end

	let(:solution) { Factories::Solution.for( Factories::Assignment.vending_machine ) }

	it "should allow to set name" do
	  file = SolutionGenericFile.new
	  
	  file.name = 'myfile'
	  file.name.should == 'myfile'
	end

	it "should return nil on name if path is not set" do
	  file = SolutionGenericFile.new
		
		file.path.should be_nil
		file.name.should be_nil
	end

	it "should not raise error if nil is attempted to be assigned to name" do
	  file = SolutionGenericFile.new

	  expect { file.name = nil }.not_to raise_error
	end

	it "should validate presence of path" do
	  file = SolutionGenericFile.new

		file.path.should be_nil
		file.should_not be_valid
		file.save.should be_false
	end

	it "should set definitive path on save" do
	  file = SolutionGenericFile.new 

	  file.name = 'myFile'

	  file.path.should == "/solutions/temp/myfile"

	  file.solution = solution

	  file.save

	  file.path.should == "/solutions/#{solution.id}/myfile"
	end

	it "should not allow to change the name after set" do
	  file = SolutionGenericFile.new
		file.name = 'myFile'

		expect { file.name = 'anotherFile' }.to raise_error(CannotUpdateNameError)
	end

	it "should not raise error if path is set twice with same value" do
	  file = SolutionGenericFile.new
		file.name = 'myFile'

		expect { file.name = 'MYFILE' }.not_to raise_error(CannotUpdateNameError)
	end
end
