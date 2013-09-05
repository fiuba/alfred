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
    assignment_name.gsub!(' ', '-')
    "grading_report_for_#{assignment_name}.csv"
  end

  def self.report(assignment)
    options = { :col_sep => ';', :headers => true, :encoding => 'UTF-8' }

    CSV.generate(options) do |csv|
      csv << self.headers

      assignment.course.students.each do | student |
        assignment_status = student.status_for_assignment(assignment)
        csv << [  assignment.course.name,
                  student.tag,
                  student.buid,
                  student.full_name,
                  I18n.t( assignment_status.status ),
                  format_date( assignment_status.latest_solution_date ),
                  assignment_status.grade || '',
                  assignment_status.corrector_name || '' ] 
      end
    end
  end

  private
    def self.format_date( date )
      return '' if date.nil?
      date.strftime( I18n.t('date.formats.default') )
    end

end
