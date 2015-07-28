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

  def total_solutions
    clean_solutions.count
  end

  def general_average
    average_for corrected_solutions
  end

  def approved_average
    average_for solutions_approved
  end

  private
  def average_for(solutions)
    return 0 if solutions.empty?
    solutions.map { |solution| solution.correction.grade }.reduce(:+) / solutions.count
  end

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
    return [] unless solutions.present?
    solutions.select{ |solution| solution.correction.present? unless solution.nil? }
  end

end