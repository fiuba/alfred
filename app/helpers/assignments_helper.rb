Alfred::App.helpers do

  def errors_for form_field
    @assignment.errors.key?(form_field) && @assignment.errors[form_field].count > 0
  end

  def show_average average
    return "--" if average == 0
    average
  end

  def assignment_report assignment
    AssignmentStatistics.new(assignment)
  end
end