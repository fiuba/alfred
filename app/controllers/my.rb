Alfred::App.controllers :my do
  before do
    @course = Course.find_by_name(params[:course_id])
  end

  get :index do
    @title = "Students"    
    
    @students = @course.students
    render 'my/index'
  end

  get :assigments, :parent => :courses do
    assignments = Assignment.find_by_course(current_course)
    @assignment_status = []
    assignments.each do | assignment |
      @assignment_status << current_account.status_for_assignment(assignment)
    end
    render 'my/assignments'
  end

  get :solutions, :parent => :assignments do
    @solutions = Solution.all(:account => current_account, :assignment_id => params[:assignment_id])
    render 'my/solutions'
  end

  get '/assigments/:assignment_id/solutions/:solution_id' do
    render 'students/solution_detail'
  end

end
