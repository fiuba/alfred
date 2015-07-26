require 'spec_helper'

describe "AssignmentsStats" do

  before(:each) do
    @assignment = Factories::Assignment.vending_machine
    @author     = Factories::Account.me_as_student
    @solution   = Factories::Solution.forBy( @assignment, @author )
    @teacher    = Factories::Account.me_as_teacher
    @correction = Factories::Correction.correctsBy(@solution, @teacher)
  end

  describe 'assignment_name' do
    it "assignment_name should return assignment name" do
      stats = AssignmentsStats.new(@assignment)
      expect(stats.assignment_name).to eq @assignment.name
    end
  end
  
end

