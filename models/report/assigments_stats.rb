class AssignmentsStats

  def self.for(assignments) 
    stats = []
    assignments.each do |a|
      stats << AssignmentsStats.new(a)
    end
  end

  def initialize(assignment)
    @assignment = assignment
    students = @assignment.course.students
    students.each do |s|
      @solutions = Solution.latest_by_student_and_assignment(student, @assignment)
    end
  end

  def assignment_name
    @assignment.name
  end

  def total_solutions
    @solutions.count
  end

  def passed 
    #corrected_solutions_for(assignment).select{ |solution| solution.correction.approved? }
  end

  def failed
  end

  def passed_average

  end

  def general_average
  end

end
