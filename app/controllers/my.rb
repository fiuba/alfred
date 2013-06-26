Alfred::App.controllers :my, :parent => :courses do
  get :index do
    @title = "Students"    
    course = Course.find_by_name(params[:course_id])
    @students = course.students
    render 'students/index'
  end

  get :assigments do
    render 'students/me'
  end

  get '/assigments/:assignment_id/solutions' do
    render 'students/solutions'
  end

  get '/assigments/:assignment_id/solutions/:solution_id' do
    render 'students/solution_detail'
  end

end
