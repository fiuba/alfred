Alfred::App.controllers :karmas do

  post :register, :provides => :json do
    course = Course.active
    student = Account.get(params[:student_id])
    return 404 if student.nil?
    karma = Karma.for_student_in_course(student, course)
    karma.description = Date.today.to_s
    karma.save
    new_karma = Karma.count_for_student_in_course(student, course)
    Oj.dump({ 'new_karma' => new_karma})
  end

end
