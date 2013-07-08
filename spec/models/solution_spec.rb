require 'spec_helper'

describe Solution do

	before (:all) do
		DataMapper.auto_migrate!
		course = Course.new( :name => "AlgoIII", :active => true )
    @student = Factories::Account.student
		assignment = Factories::Assignment.vending_machine
		@solution = Factories::Solution.forBy( assignment, @student )
	end

	subject { @solution }

	it { should respond_to( :file ) }
	it { should respond_to( :account ) }
	it { should respond_to( :assignment) }
	it { should respond_to( :correction) }

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

end
