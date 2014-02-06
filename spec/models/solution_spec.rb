require 'spec_helper'

describe Solution do

	before (:all) do
		course = Course.new( :name => "AlgoIII", :active => true )
    @student = Factories::Account.student
		@assignment = Factories::Assignment.vending_machine
		@solution = Factories::Solution.forBy( @assignment, @student )
	end

	subject { @solution }

	it { should respond_to( :file ) }
	it { should respond_to( :account ) }
	it { should respond_to( :assignment) }
	it { should respond_to( :correction) }
	it { should respond_to( :test_result) }
	it { should respond_to( :test_output) }

	describe "should belongs to student" do
		it { @solution.account.should == @student }
	end

	describe "without file" do
    before { @solution.file = nil }
		it { should_not be_valid }
	end

	describe "with file" do
		before { @solution.file = 'resource name' }
    it { should be_valid }
	end

  describe "solutions by student for specified assignment" do
    before do
      @anohter_solution = Factories::Solution.forBy( @assignment, @student )
      @final_solution = Factories::Solution.forBy( @assignment, @student )
    end

    describe "set of solutions" do
      it "should response both solutions" do
        solutions = Solution.get_by_student_and_assignment(@student, @assignment)
        solutions.should include(@anohter_solution)
        solutions.should include(@final_solution)
      end
    end

    describe "latest solution" do
      latest = Solution.latest_by_student_and_assignment(@student, @assignment)
      latest.should == @final_solution
    end
  end

end
