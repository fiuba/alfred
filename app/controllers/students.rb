Alfred::App.controllers :students, :parent => :courses do

  get :index do
    @title = "Students"
    course = Course.find_by_name(params[:course_id])
    @students = course.students
    render 'students/index'
  end

  get ':student_id/assignments' do
    @student = Account.get(params[:student_id])
    assignments = Assignment.find_by_course(current_course)
    @assignment_status = []
    assignments.each do | assignment |
      @assignment_status << @student.status_for_assignment(assignment)
    end
  	render 'students/detail'
  end

end
