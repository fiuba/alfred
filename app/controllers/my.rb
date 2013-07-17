Alfred::App.controllers :my, :parent => :courses do
  before do
    @course = Course.find_by_name(params[:course_id])
  end

  get :index do
    @title = "Students"    
    
    @students = @course.students
    render 'students/index'
  end

  get :assigments do
    assignments = Assignment.find_by_course(current_course)
    @assignment_status = []
    assignments.each do | assignment |
      @assignment_status << current_account.status_for_assignment(assignment)
    end

    render 'students/assignments'
  end

  get '/assigments/:assignment_id/solutions' do
    render 'students/solutions'
  end

  get '/assigments/:assignment_id/solutions/:solution_id' do
    render 'students/solution_detail'
  end

end
