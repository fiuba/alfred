Alfred::App.helpers do

  def student_karma
    Karma.count_for_student_in_course(current_account, current_course)
  end
end