require 'spec_helper'

describe "GradingReport" do
  let(:date_format) { '%d/%m/%Y' }

  before(:each) do
    DataMapper.auto_migrate!
    @assignment = Factories::Assignment.vending_machine
    @author     = Factories::Account.me_as_student
    @solution   = Factories::Solution.forBy( @assignment, @author )
    @teacher    = Factories::Account.me_as_teacher
    @correction = Factories::Correction.correctsBy(@solution, @teacher) 
    I18n.stub(:t).with('date.formats.default').and_return(date_format)
    I18n.stub(:t).with('grading_report.course').and_return('Curso')
    I18n.stub(:t).with('grading_report.shift').and_return('Turno')
    I18n.stub(:t).with('grading_report.buid').and_return('Padron')
    I18n.stub(:t).with('grading_report.student').and_return('Estudiante')
    I18n.stub(:t).with('grading_report.solution_date').and_return('Fecha entrega')
    I18n.stub(:t).with('grading_report.grade').and_return('Nota')
    I18n.stub(:t).with('grading_report.teacher').and_return('Docente')
    I18n.stub(:t).with('grading_report.status').and_return('Estado')
  end

  describe "report" do
    it "should response headers as first line" do
      stream_csv = GradingReport.report( @assignment )
      expected_headers = [ 'Curso', 'Turno', 'Padron', 'Estudiante', 
              'Fecha entrega', 'Nota', 'Docente', 'Estado' ]

      headers = stream_csv.parse_csv( { :col_sep => ';' } )

      expected_headers.each do |h| 
        headers.should include( h )
      end
      
    end
  end
end

