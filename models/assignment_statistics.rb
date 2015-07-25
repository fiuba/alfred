class AssignmentStatistics

  def initialize assignment
    @assignment = assignment
  end

  def passed
    solutions_approved.count
  end

  def failed
    not_approved_solutions.count
  end

  private
  def solutions_approved
    corrected_solutions.select{ |solution| solution.correction.approved? }
  end

  def not_approved_solutions
    corrected_solutions.reject{ |solution| solution.correction.approved? }
  end

  def corrected_solutions
    corrected(clean_solutions)
  end

  def clean_solutions
    @assignment.solutions.group_by(&:account).map{|account, solutions| highest_rated_solution(solutions) }
  end

  def highest_rated_solution(solutions)
    corrected(solutions).max_by {|solution| solution.correction.grade }
  end

  def corrected(solutions)
    solutions.select{ |solution| solution.correction.present? }
  end
=begin
  def failed_for assignment
    corrected_solutions_for(assignment).reject{ |solution| solution.correction.approved? }.count
  end

  def total_solutions_for assignment
    assignment.solutions.count
  end

  def approved_average_for assignment
    passed = passed_for(assignment)

    if passed > 0
      approved_grades_sum(assignment) / passed
    else
      "--"
    end
  end

  def general_average_for assignment
    corrected_solutions_count = corrected_solutions_for(assignment).count

    if corrected_solutions_count > 0
      grades_sum(assignment) / corrected_solutions_count
    else
      "--"
    end
  end

  def corrected_solutions_for assignment
    assignment.solutions.select{ |solution| solution.correction.present? }
  end

  def approved_grades_sum(assignment)
    grades_sum(solutions_approved_for(assignment))
  end

  def grades_sum(assignment)
    grades_for(corrected_solutions_for(assignment)).reduce(:+) || 0
  end

  private
  def grades_for(solutions)
    solutions.correction.map(&:grade)
  end
=end
end