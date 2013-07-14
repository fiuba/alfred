require 'spec_helper'

describe "SolutionsController" do
  let(:gateway) { double(Storage::DropboxGateway) }
  let(:student) { Factories::Account.student }
  let(:another_student) { Factories::Account.student( "Bruce", "bruce@d.com" ) }
  let(:assignment) { Factories::Assignment.vending_machine}

  before (:each) do
    DataMapper.auto_migrate!
    Storage::StorageGateways.stub(:get_gateway).and_return(gateway)
		Alfred::App.any_instance.stub(:current_account).and_return(student)
  end

	describe "index" do
    before do
      @solution = Factories::Solution.for( assignment ) 
    end

		it "should response student's solution for one specified assignment" do
      Assignment.should_receive(:find_by_id).with(assignment.id.to_s)
        .and_return(assignment)
			Solution.should_receive(:all)
        .with( :account => @solution.account, :assignment => @solution.assignment)
        .and_return(@solution)
			Alfred::App.any_instance.should_receive(:render).with('solutions/index').and_return({})
			get "/assignment/#{assignment.id}/solutions"
		end
	end

  describe "new" do 
    before do
      @solution = Factories::Solution.for( assignment ) 
    end

		it "should render solution upload page of student's for specified assignment" do
      Assignment.should_receive(:find_by_id).with(assignment.id.to_s)
        .and_return(assignment)
			Solution.should_receive(:new)
        .with( :account => @solution.account, :assignment => @solution.assignment)
        .and_return(@solution)
			Alfred::App.any_instance.should_receive(:render).with('solutions/new').and_return({})
			get "/assignment/#{assignment.id}/solutions/new"
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
          :account_id => student.id,
          :assignment_id => assignment.id
        }
      }

      Storage::StorageGateways.should_receive(:get_gateway).and_return(gateway)
		end

		describe "with valid provided datas" do
			before do
      	gateway.should_receive(:upload).with('/solutions/1/submission.st', 
       		'solution content')
			end

    	it "should add both solution and solution_generic_file" do
				post "/assignment/#{assignment.id}/solutions/create", @params

      	new_solution = Solution.all.first
      	generic_file = new_solution.solution_generic_files.first
      
      	new_solution.file.should == @file_name
      	generic_file.solution.should == new_solution
    	end
		end

		describe "with dropbox connection problems" do
			before do
				error = Storage::FileUploadFailedError.new(StandardError.new)
      	gateway.should_receive(:upload)
					.with('/solutions/1/submission.st', 'solution content')
					.and_raise(error)
			end

    	it "should not add either solution or solution_generic_file" do
				post "/assignment/#{assignment.id}/solutions/create", @params
      	Solution.all.size.should be_equal(0)
				SolutionGenericFile.all.size.should be_equal(0)
    	end

		end
	end

	describe "file" do 
		describe "with an existing solution" do
			before do
				@new_solution = Factories::Solution.for( assignment )
				@file_name = @new_solution.file
        @owner = @new_solution.account

				Alfred::App.any_instance.stub(:current_account)
          .and_return(@owner)
			end

			it "should respond solution's file" do
        Solution.should_receive(:find)
          .with(@new_solution.id.to_s)
          .and_return(@new_solution)

      	gateway.should_receive(:download)
          .with("/solutions/#{@new_solution.id}/#{@file_name}")

				get "/assignment/#{@new_solution.assignment.id}/solutions/file/#{@new_solution.id}"
        last_response.status.should == 200
			end

      describe "unauthorized student tries to download other's solution" do
        before do
				  Alfred::App.any_instance.stub(:current_account)
            .and_return(another_student)
        end

        it "should not respond solution belonging to other student" do
				  get "/assignment/#{@new_solution.assignment.id}/solutions/file/#{@new_solution.id}"
          last_response.status.should == 404
        end
      end
    end

		describe "with an solution which doesn't exist" do
			before do
				solution = Factories::Solution.for( assignment )
      end
      it "should respond with error 404" do
				get "/assignment/#{Assignment.all.first.id}/solutions/file/99999"
        last_response.status.should == 404
      end
    end

	end
end
