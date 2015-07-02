Alfred::App.helpers do

  def errors_for form_field
    @assignment.errors.key?(form_field) && @assignment.errors[form_field].count > 0
  end

  def passed_for assignment
    solutions_approved_for(assignment).count
  end

  def failed_for assignment
    corrected_solutions_for(assignment).reject{ |solution| solution.correction.approved? }.count
  end

  def total_solutions_for assignment
    assignment.solutions.count
  end

  def approved_average_for assignment
    if passed_for(assignment) > 0
      approved_grades_sum(assignment) / passed_for(assignment)
    else
      "--"
    end
  end

  def general_average_for assignment
    if corrected_solutions_for(assignment).count > 0
      grades_sum(assignment) / corrected_solutions_for(assignment).count
    else
      "--"
    end
  end

  def corrected_solutions_for assignment
    assignment.solutions.select{ |solution| solution.correction.present? }
  end

  def solutions_approved_for assignment
    corrected_solutions_for(assignment).select{ |solution| solution.correction.approved? }
  end

  def approved_grades_sum(assignment)
    grades_for(solutions_approved_for(assignment))
  end

  def grades_sum(assignment)
    grades_for(corrected_solutions_for(assignment))
  end

  private
  def grades_for(solutions)
    solutions.map{ |solution| solution.correction.grade }.reduce(:+) || 0
  end
end