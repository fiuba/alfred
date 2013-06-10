require 'spec_helper'

describe Solution do
	let(:course) { Course.new( :name => "AlgoIII", :active => true ) }
	let(:account) do
		Account.create( :email => "x@x.com", :password => "foobar",
								:password_confirmation => "foobar",
								:role => "student", :buid => "?"	)
	end
	let(:assignment) { Assignment.create( :course => course ) }

	before do
		@solution =
			Solution.new( :assignment => assignment, 
										 :account => account ) 
	end
	subject { @solution }

	it { should respond_to( :file ) }
	it { should respond_to( :account ) }
	it { should respond_to( :assignment) }

	describe "should belongs to student" do
		it { @solution.account.should == account }
	end

	describe "without file" do
		it { should_not be_valid }
	end

	describe "with file" do
		before { @solution.file = 'resource name' }
		it { should be_valid }
	end


end
