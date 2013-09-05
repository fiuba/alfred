require 'spec_helper'
require 'i18n'

describe "GradingReport" do
  let(:csv_options) { { :col_sep => ';' } } 
  let(:date_format) { '%d/%m/%Y' }

  before(:each) do
    DataMapper.auto_migrate!
    @assignment = Factories::Assignment.tp
    @author     = Factories::Account.me_as_student
    @solution   = Factories::Solution.forBy( @assignment, @author )
  end

  describe "report" do

    describe "whether solution has not been assigned yet" do
      before do
        stream_csv = GradingReport.report( @assignment )
        @reader = CSV.instance( stream_csv, csv_options )
      end

      it "should contain status for student solution without correction info" do
        expected_row = []
        expected_row << @author.courses.first.name
        expected_row << @author.tag
        expected_row << @author.buid
        expected_row << @author.full_name()
        expected_row << I18n.t(:correction_pending)
        expected_row << @solution.created_at.to_date.strftime( date_format )
        expected_row << ''
        expected_row << ''


        @reader.shift()       # It skips headers
        row = @reader.shift()

        row.should == expected_row
      end
    end

    describe "whether solution was assigned but it has not been graded yet" do
      before do
        teacher    = Factories::Account.me_as_teacher 
        @correction = Factories::Correction.correctsBy(@solution, teacher) 
        @correction.grade = nil
        @correction.save
        stream_csv = GradingReport.report( @assignment )
        @reader = CSV.instance( stream_csv, csv_options )
      end

      it "should contain status for student solution without correction grading" do
        expected_row = []
        expected_row << @author.courses.first.name
        expected_row << @author.tag
        expected_row << @author.buid
        expected_row << @author.full_name()
        expected_row << I18n.t(:correction_in_progress)
        expected_row << @solution.created_at.to_date.strftime( date_format )
        expected_row << ''
        expected_row << @correction.teacher.full_name()


        @reader.shift()       # It skips headers
        row = @reader.shift()

        row.should == expected_row
      end

    end

    describe "whether solution was assigned and graded" do
      before do
        @teacher    = Factories::Account.me_as_teacher
        @correction = Factories::Correction.correctsBy(@solution, @teacher) 
        stream_csv = GradingReport.report( @assignment )
        @reader = CSV.instance( stream_csv, csv_options )
      end

      it "should response headers as first line" do
        expected_headers = []
        expected_headers << I18n.t('grading_report.course')
        expected_headers << I18n.t('grading_report.shift')
        expected_headers << I18n.t('grading_report.buid')
        expected_headers << I18n.t('grading_report.student')
        expected_headers << I18n.t('grading_report.status')
        expected_headers << I18n.t('grading_report.solution_date')
        expected_headers << I18n.t('grading_report.grade')
        expected_headers << I18n.t('grading_report.teacher')

        headers = @reader.shift()

        expected_headers.each do |h| 
          headers.should include( h )
        end
      end

      it "should contain status for student solution" do
        expected_row = []
        expected_row << @author.courses.first.name
        expected_row << @author.tag
        expected_row << @author.buid
        expected_row << @author.full_name()
        expected_row << I18n.t(:correction_passed)
        expected_row << @solution.created_at.to_date.strftime( date_format )
        expected_row << @correction.grade.to_s
        expected_row << @correction.teacher.full_name()


        @reader.shift()       # It skips headers
        row = @reader.shift()

        row.should == expected_row
      end

      describe "student submits a new solution after teacher has graded his/her previous one" do
        before do
          another_solution = Factories::Solution.forBy( @assignment, @author )
          second_report = GradingReport.report( @assignment )
          @reader = CSV.instance( second_report, csv_options )
        end

        it "should report graded one" do
          expected_row = []
          expected_row << @author.courses.first.name
          expected_row << @author.tag
          expected_row << @author.buid
          expected_row << @author.full_name()
          expected_row << I18n.t(:correction_passed)
          expected_row << @solution.created_at.to_date.strftime( date_format )
          expected_row << @correction.grade.to_s
          expected_row << @correction.teacher.full_name()

          @reader.shift()       # It skips headers
          row = @reader.shift()

          row.should == expected_row
        end

      end
    end
  end
end

