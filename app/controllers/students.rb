Alfred::App.controllers :students, :parent => :course do
  get :index do
    @title = "Students"    
    course = Course.find_by_name(params[:course_id])
    @students = course.students
    render 'students/index'
  end
end
