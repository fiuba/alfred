Alfred::App.controllers :students, :parent => :courses do
  get :index do
    @title = "Students"    
    course = Course.find_by_name(params[:course_id])
    @students = course.students
    render 'students/index'
  end

  get :detail do
  	render 'students/detail'
  end

  get :correction do
  	render 'students/correction'
  end

  get :me do
    render 'students/me'
  end

end
