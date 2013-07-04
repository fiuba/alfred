require 'spec_helper'

describe "SolutionsController" do
  before (:each) do
    DataMapper.auto_migrate!

     @gateway = double(Storage::DropboxGateway)
     Storage::StorageGateways.stub(:get_gateway)
     	.and_return(@gateway)
  end

  let(:student) { Factories::Account.student }
  let(:another_student) { Factories::Account.student( "Bruce", "b@d.com" ) }
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
          :account_id => student.id,
          :assignment_id => assignment.id
        }
      }

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
				Alfred::App.any_instance.stub(:current_account).and_return(student)
				error = Storage::FileUploadFailedError.new(StandardError.new)
      	@gateway.should_receive(:upload)
					.with('/solutions/1/submission.st', 'solution content')
					.and_raise(error)
			end

    	it "should not add either solution or solution_generic_file" do
				post '/solutions/create', @params
      	Solution.all.size.should be_equal(0)
				SolutionGenericFile.all.size.should be_equal(0)
    	end

		end
	end

	describe "destroy" do
		before do
			@solution = Factories::Solution.for( 
				Factories::Assignment.vending_machine )
			@solution_to_delete = Factories::Solution.for( 
				Factories::Assignment.vending_machine )
			@file_name = @solution_to_delete.file

			Alfred::App.any_instance.stub(:current_account)
      	.and_return(@solution_to_delete.account)
		end

		describe "when storage file error arise" do
			it "should not remove either solution, solution_generic_file and storage_file" do
				error = Storage::FileDeleteError.new(StandardError.new)
 		    @gateway.should_receive(:delete)
        	.with("/solutions/#{@solution_to_delete.id}/#{@file_name}")
					.and_raise(error)

				expect { delete "/solutions/destroy/#{@solution_to_delete.id}" }
					.not_to change{ Solution.all.size }.from(2).to(2)
			end
		end

		it "should remove the solution, solution_generic_file and storage file" do
      @gateway.should_receive(:delete)
          .with("/solutions/#{@solution_to_delete.id}/#{@file_name}")

			expect { delete "/solutions/destroy/#{@solution_to_delete.id}" }
				.to change{ Solution.all.size }.from(2).to(1)
		end

		describe "unauthorized student tries to delete other's solution" do
			before do
				  Alfred::App.any_instance.stub(:current_account)
            .and_return(another_student)
			end

			it "should not remove either the solution or solution_generic_files" do
				expect { delete "/solutions/destroy/#{@solution_to_delete.id}" }
					.not_to change{ Solution.all.size }.from(2).to(2)
        last_response.status.should == 403
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

      	@gateway.should_receive(:download)
          .with("/solutions/#{@new_solution.id}/#{@file_name}")

				get "/solutions/file/#{@new_solution.id}"
        last_response.status.should == 200
			end

      describe "unauthorized student tries to download other's solution" do
        before do
				  Alfred::App.any_instance.stub(:current_account)
            .and_return(another_student)
        end

        it "should not respond solution belonging to other student" do
          get "/solutions/file/#{@new_solution.id}"
          last_response.status.should == 404
        end
      end
    end

		describe "with an solution which doesn't exist" do
      it "should respond with error 404" do
				get "/solutions/file/999999"
        last_response.status.should == 404
      end
    end

	end

end
