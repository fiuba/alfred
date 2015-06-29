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

  def average_for assignment
    if passed_for(assignment) > 0
      approved_grades_sum(assignment) / passed_for(assignment)
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
    solutions_approved_for(assignment).map{ |solution| solution.correction.grade }.reduce(:+) || 0
  end

end