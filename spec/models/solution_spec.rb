require 'spec_helper'

describe Solution do

	before (:all) do
		DataMapper.auto_migrate!
		course = Course.new( :name => "AlgoIII", :active => true )
		@account = Account.create( :email => "x@x.com", :password => "foobar",
								:password_confirmation => "foobar",
								:role => "student", :buid => "?"	)
		assignment = Assignment.create( :course => course )

		@solution =
			Solution.new( :assignment => assignment, 
										 :account => @account ) 
	end

	subject { @solution }

	it { should respond_to( :file ) }
	it { should respond_to( :account ) }
	it { should respond_to( :assignment) }

	describe "should belongs to student" do
		it { @solution.account.should == @account }
	end

	describe "without file" do
		it { should_not be_valid }
	end

	describe "with file" do
		before { @solution.file = 'resource name' }
		it { should be_valid }
	end


end
