require 'spec_helper'

describe "SolutionsController" do
  before (:each) do
    DataMapper.auto_migrate!
  end

  let(:account) { Factories::Account.student }
  let(:assignment) { Factories::Assignment.vending_machine}
	
	it "should query Solutions" do
		Solution.should_receive(:all).and_return([])
		Alfred::App.any_instance.should_receive(:render).with('solutions/index').and_return({})
		get '/solutions'
	end

  describe "solution upload without erros" do
    it "should add both solution and solution_generic_file" do
      file_name = 'submission.st'
      file_content = 'solution content'
      params = { 
        :solution => { 

          :file => {
            :filename => file_name, 
            :tempfile => file_content
          },
          :account_id => account.id,
          :assignment_id => assignment.id
        }
      }

      gateway = double(Storage::DropboxGateway)
      gateway.should_receive(:upload).with('/solutions/1/submission.st', 
        'solution content')
      Storage::StorageGateways.should_receive(:get_gateway).and_return(gateway)

      post '/solutions/create', params

      new_solution = Solution.all.first
      generic_file = new_solution.solution_generic_files.first
      
      new_solution.file.should == file_name
      generic_file.solution.should == new_solution

    end
  end
end
