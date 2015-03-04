class CorrectionStatus

  attr_accessor :assignment_id, :assignment_name, :student_id, :student_full_name, :student_buid, :solution_id, :solution_test_result, :correction_id, :status, :grade, :assignment_solution_type, :link, :is_overdue

  def self.corrections_status_for_teacher(teacher, course)
    query = <<-SQL
      SELECT DISTINCT s.account_id,s.assignment_id
      FROM corrections c
      INNER JOIN solutions s ON s.id = c.solution_id
      INNER JOIN assignments a ON a.id = s.assignment_id
      WHERE c.teacher_id = #{teacher.id} AND a.course_id = #{course.id}
    SQL
    assigned_corrections = repository(:default).adapter.select(query)
    assigned_corrections.collect do |ac|
      solution = Solution.last(:account_id => ac.account_id, :assignment_id => ac.assignment_id, :order => :created_at)
      create_from_latest_solution(solution)
    end
  end

  private

  def self.create_from_latest_solution(solution)
    correction_status = CorrectionStatus.new
    correction_status.assignment_id = solution.assignment.id
    correction_status.assignment_name = solution.assignment.name
    correction_status.student_id = solution.account.id
    correction_status.student_full_name = solution.account.full_name
    correction_status.student_buid = solution.account.buid
    correction_status.solution_id = solution.id
    correction_status.solution_test_result = solution.test_result
    correction_status.is_overdue = solution.is_overdue?
    correction_status.assignment_solution_type = solution.type
    correction_status.link = solution.link
    if solution.correction.nil?
      correction_status.status = :correction_pending
    else
      correction_status.correction_id = solution.correction.id
      correction_status.status = solution.correction.status
      correction_status.grade = solution.correction.grade
    end

    correction_status
  end
end
