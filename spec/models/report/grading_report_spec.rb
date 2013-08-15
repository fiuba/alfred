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
  end

  describe "solution with graded and ranked" do
    let(:expected) { 
      "#{@author.courses.first.name};" +
      "#{@author.tag};" +
      "#{@author.buid};" +
      "#{@author.prety_full_name};" +
      Date.today.strftime(date_format) + ";" +
      "#{@assignment.name};" +
      Date.today.strftime(date_format) + ";" +
      "7.0;" +
      "#{@teacher.prety_full_name}" 
    }

    it "should response fully populated" do
      @solution.as_csv.should == expected
    end
  end

  describe "not ranked" do
  end

  describe "not assigned" do
  end

  describe "report" do
  end
end

