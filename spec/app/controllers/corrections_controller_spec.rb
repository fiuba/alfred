require 'spec_helper'

describe "CorrectionsController" do
  let(:teacher) { Factories::Account.teacher }
  let(:algorithm) { Factories::Course.algorithm }
  let(:solution) { Factories::Solution.for( Factories::Assignment.vending_machine ) }

	before (:each) do
		DataMapper.auto_migrate!

		Alfred::App.any_instance.stub(:current_account)
      .and_return(Factories::Account.teacher)
		Alfred::App.any_instance.stub(:current_course)
      .and_return(Factories::Course.algorithm)
	end

	describe "index" do
		it "should respond with error 403 whether not a teacher access to" do
		  Alfred::App.any_instance.stub(:current_account)
        .and_return(Factories::Account.student)
			get "/courses/#{algorithm.id}/corrections"
			last_response.status.should == 403
		end

		it "should render index content" do
			Correction.should_receive(:all)
				.with(:teacher => teacher)
				.and_return([])
			Alfred::App.any_instance.should_receive(:render)
				.with('corrections/index').and_return({})
			get "/courses/#{algorithm.id}/corrections"
		end
	end

	describe "create" do
		before do
    	@params = { 
      	:correction => { 
						:solution_id => solution.id
				}
			}
		end

		describe "student tries to create a solution" do
			it "should response 403" do
		    Alfred::App.any_instance.stub(:current_account)
          .and_return(Factories::Account.student)
				post "/courses/#{algorithm.id}/corrections/create", @params
				last_response.status.should == 403
			end
		end

		describe "teacher creates a solution" do
			it "should create a new correction" do
				expect { post "/courses/#{algorithm.id}/corrections/create", @params}
					.to change{ Correction.all(:teacher => teacher).size }.from(0).to(1)
			end
		end
	end

	describe "edit" do 
		it "should render index content" do
			correction = Factories::Correction.correctsBy( solution, teacher )
			Correction.should_receive(:get).with(correction.id)
				.and_return(correction)
			Alfred::App.any_instance.should_receive(:render)
				.with('corrections/edit').and_return({})
			get "/courses/#{algorithm.id}/corrections/edit/#{correction.id}"
		end
	end

  describe "update" do
    before do
			@correction = Factories::Correction.correctsBy( solution, teacher )

      @public_comments = "public new comments"
      @private_comments = "private new comments"

    	@params = { 
      	:correction => { 
						:solution_id => solution.id,
            :public_comments => @public_comments,
            :private_comments => @private_comments,
            :grade => 7
				}
			}

      Correction.should_receive(:get).with(@correction.id)
        .and_return(@correction)
    end

    describe "when correction is updated" do
      it "should change correction's datas" do
  			put "/courses/#{algorithm.id}/corrections/update/#{@correction.id}", @params

        @correction.public_comments.should == @public_comments
        @correction.private_comments.should == @private_comments
        @correction.grade.should == 7
      end

      describe "when grade is nil" do
        before do
          @correction.public_comments = @public_comments
          @correction.private_comments = @private_comments
          @correction.grade = 8
          @correction.save
        end

        it "should update correction" do
          @params[:correction][:grade] = nil
          @correction.grade.should_not == nil
	    		put "/courses/#{algorithm.id}/corrections/update/#{@correction.id}", @params
          @correction.grade.should == nil
        end
      end
    end
  end
end
