require 'spec_helper'

describe "CorrectionsController" do
  let(:teacher) { Factories::Account.teacher }
  let(:algorithm) { Factories::Course.algorithm }
  let(:assignment) { Factories::Assignment.vending_machine }
  let(:solution) { Factories::Solution.for(assignment) }

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
      CorrectionStatus.should_receive(:corrections_status_for_teacher)
        .with(teacher)
        .and_return([])
      Alfred::App.any_instance.should_receive(:render)
        .with('corrections/index')

      get "/courses/#{algorithm.id}/corrections"
    end
  end

  describe "create" do
    before do
      @params = {
        :student_id => solution.account.id,
        :assignment_id => assignment.id
      }
    end

    describe "student tries to create a correction" do
      it "should response 403" do
        Alfred::App.any_instance.stub(:current_account)
          .and_return(Factories::Account.student)
        post "/corrections/create", @params
        last_response.status.should_not == 200
      end
    end

    describe "teacher assings himself correction of a solution" do
      before do
        @author = solution.account
        @first_solution = Factories::Solution.forBy( assignment, @author )
        @second_solution = Factories::Solution.forBy( assignment, @author )

        # It ensures that creation dates are differents
        @second_solution.created_at = @first_solution.created_at + 2

        Alfred::App.any_instance.stub(:current_account)
          .and_return(teacher)
      end

      it "should bind correction with last solution" do
        solutions = Solution.all(:account => @author, :assignment => assignment, :order => [ :created_at.desc ])
        solutions.size.should > 2
        @first_solution.created_at.should < @second_solution.created_at
        Correction.all.size.should == 0

        @params[:teacher_id] = teacher.id
        post "/corrections/assign_to_teacher/#{solution.account.id}/#{assignment.id}/#{teacher.id}.json"

        last_response.status.should == 200
        created_correction = Correction.all.last
        created_correction.teacher.should == teacher
        created_correction.solution.id.should == @second_solution.id
        created_correction.created_at.to_date.should == Date.today.to_date
      end
    end

    it "should display error message if correction cannot be created" do
      failed_correction_double = double(:id => nil, :errors => {:grade => ['cannot be blank']}, :solution => solution)
      failed_correction_double.should_receive(:saved?).and_return(false)
      Correction.should_receive(:create).with(any_args).and_return(failed_correction_double)
      Alfred::App.any_instance.stub(:current_account).and_return(teacher)

      correction_params = { :public_comments => 'my public comment', :private_comments => 'my private comment', :grade => '10' }
      post '/solution/1/corrections/create', { :correction => correction_params }
    end

    context 'correction successfully created' do
      let(:teacher) { Factories::Account.teacher }
      let(:created_correction) { double(:id => 101, :saved? => true, :teacher => teacher) }
      let(:correction_params) { { 'public_comments' => 'my public comment', 'private_comments' => 'my private comment', 'grade' => '10' } }
      let(:solution_id) { "123" }

      before do
        Correction
          .should_receive(:create)
          .with(correction_params.merge({'solution_id' => solution_id, 'teacher_id'=>teacher.id}))
          .and_return(created_correction)
      end

      it "should create a new correction without notifying" do
        Alfred::App.should_not_receive(:deliver)

        post "/solution/#{solution_id}/corrections/create", { :correction => correction_params }
      end

      it "should create a new correction and notify" do
        Alfred::App.should_receive(:deliver).with(:notification, :correction_result, created_correction)

        post "/solution/#{solution_id}/corrections/create", { :correction => correction_params, :save_and_notify => 'true' }
      end
    end
  end

  describe "edit" do
    it "should render index content" do
      correction = Factories::Correction.correctsBy( solution, teacher )
      Correction.should_receive(:get).with(correction.id.to_s)
        .and_return(correction)
      Alfred::App.any_instance.should_receive(:render)
        .with('corrections/edit').and_return({})
      get "/corrections/edit/#{correction.id}"
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

      Correction.should_receive(:get).with(@correction.id.to_s)
        .and_return(@correction)
    end

    describe "when correction is updated" do
      it "should change correction's datas" do
        put "/courses/#{algorithm.id}/corrections/update/#{@correction.id}", @params

        @correction.public_comments.should == @public_comments
        @correction.private_comments.should == @private_comments
        @correction.grade.should == 7
      end

      it "should call mail deliver when save_and_notify is present" do
        addtional_params = { :save_and_notify => 'save_and_notify'}
        @params.merge! addtional_params
        Alfred::App.should_receive(:deliver).with(:notification, :correction_result, @correction)
        put "/courses/#{algorithm.id}/corrections/update/#{@correction.id}", @params
      end

      it "should not call mail deliver when save_and_notify is not present" do
        Alfred::App.should_not_receive(:deliver)
        put "/courses/#{algorithm.id}/corrections/update/#{@correction.id}", @params
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
