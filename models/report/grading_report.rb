require 'csv'

class GradingReport
  def self.headers
    result = []  
    result << I18n.t('grading_report.course')
    result << I18n.t('grading_report.shift')
    result << I18n.t('grading_report.buid')
    result << I18n.t('grading_report.student')
    result << I18n.t('grading_report.status')
    result << I18n.t('grading_report.solution_date')
    result << I18n.t('grading_report.grade')
    result << I18n.t('grading_report.teacher')
    result
  end

  def self.file_name(assignment)
    assignment_name = ""
    assignment_name = assignment.name unless assignment.nil?
    assignment_name.gsub(' ', '-')
    "grading_report_for_#{assignment_name}.csv"
  end

  def self.report(assignment)
    options = { :col_sep => ';', :headers => true }

    CSV.generate(options) do |csv|
      csv << self.headers

      assignment.course.students.each do | student |
        assignment_status = student.status_for_assignment(assignment)
        csv << [  assignment.course.name,
                  student.tag,
                  student.buid,
                  student.prety_full_name,
                  I18n.t( assignment_status.status ),
                  format_date( assignment_status.latest_solution_date ),
                  correction_grading(student, assignment),
                  correction_teacher(student, assignment) ] 
      end
    end
  end

  private
    def self.last_correction_for_solution_by_student_for(student, assignment)
      solutions = Solution.all(:account => student, :assignment => assignment)
      solutions.sort_by! { |s| s.created_at }
      last_solution = solutions.last

      # Responses nil if there aren't solutions or correction of 
      # last solution doesn't exist
      if last_solution.nil? or last_solution.correction.nil?
        return nil
      end

      last_solution.correction
    end

    def self.correction_teacher(student, assignment)
      if last_correction_for_solution_by_student_for(student, assignment).nil?
        return nil
      end
      last_correction_for_solution_by_student_for(student, assignment).teacher.prety_full_name
    end

    def self.correction_grading(student, assignment)
      if last_correction_for_solution_by_student_for(student, assignment).nil? or
         last_correction_for_solution_by_student_for(student, assignment).grade.nil?
        return nil
      end
      last_correction_for_solution_by_student_for(student, assignment).grade
    end

    def self.format_date( date )
      ( date.nil? ) ? "" :
        date.strftime( I18n.t('date.formats.default') )
    end
    

end
