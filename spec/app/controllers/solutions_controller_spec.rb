require 'spec_helper'

describe "SolutionsController" do
  before (:each) do
    DataMapper.auto_migrate!
  end

  let(:account) { Factories::Account.student }
  let(:assignment) { Factories::Assignment.vending_machine}
	
	describe "index" do
		it "should query Solutions" do
			Solution.should_receive(:all).and_return([])
			Alfred::App.any_instance.should_receive(:render).with('solutions/index').and_return({})
			get '/solutions'
		end
	end

	describe "create" do
		before do
      @file_name = 'submission.st'
      file_content = 'solution content'
      @params = { 
        :solution => { 

          :file => {
            :filename => @file_name, 
            :tempfile => file_content
          },
          :account_id => account.id,
          :assignment_id => assignment.id
        }
      }

      @gateway = double(Storage::DropboxGateway)
      Storage::StorageGateways.should_receive(:get_gateway).and_return(@gateway)
		end

		describe "with valid provided datas" do
			before do
      	@gateway.should_receive(:upload).with('/solutions/1/submission.st', 
       		'solution content')
			end

    	it "should add both solution and solution_generic_file" do
				post '/solutions/create', @params

      	new_solution = Solution.all.first
      	generic_file = new_solution.solution_generic_files.first
      
      	new_solution.file.should == @file_name
      	generic_file.solution.should == new_solution
    	end
		end

		describe "with dropbox connection problems" do
			before do
				Alfred::App.any_instance.stub(:current_account).and_return(account)
				error = Storage::FileUploadFailedError.new(StandardError.new)
      	@gateway.should_receive(:upload)
					.with('/solutions/1/submission.st', 'solution content')
					.and_raise(error)
			end

    	it "should not add either solution or solution_generic_file" do
				post '/solutions/create', @params
      	Solution.all.size.should be_equal(0)
    	end

		end
	end
end
