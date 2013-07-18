Alfred::App.helpers do

  def correction_status_label(status)
  	I18n.translate("assignments.status.#{status.to_sym}")
  end

  def solution_file_url( correction ) 
    solution = correction.solution
    assignment = solution.assignment
    url(:solutions, assignment.id, :file, solution.id)
  end

  def assignment_and_author_information( c )
    student = c.solution.account
    assignment_title = @correction.solution.assignment.name
    author = "#{student.surname}, #{student.name} ( #{student.buid} )"
    "#{assignment_title} - #{author}"
  end

  def solution_abridged_info( solution )
    submission_date = solution.created_at
    "#{t('corrections.submission_date')}: #{submission_date.strftime("%Y-%m-%d %H:%M:%S")}"
  end


end
