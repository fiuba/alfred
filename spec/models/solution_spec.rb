require 'spec_helper'

describe Solution do

	before (:all) do
		@solution = Solution.new
	end

	subject { @solution }

	it { should respond_to( :file ) }
	it { should respond_to( :link ) }
	it { should respond_to( :comments ) }
	it { should respond_to( :account ) }
	it { should respond_to( :assignment) }
	it { should respond_to( :correction) }
	it { should respond_to( :test_result) }
	it { should respond_to( :test_output) }

	describe 'register_test_result' do

		it 'should create correction when assigment is_optional' do
			assignment = Assignment.new
			assignment.is_optional = true
			@solution.assignment = assignment
			test_result = :passed
			test_output = 'ok'
			Correction.any_instance.should_receive(:save)
			@solution.register_test_result(test_result, test_output)
		end

	end
	
	describe 'solution type' do

		it 'should return file type of file solution' do
			assignment = Assignment.new
			assignment.solution_type = Assignment.FILE
			@solution.assignment = assignment
			expect(@solution.type).to eq Assignment.FILE
		end
		
		it 'should return link type of link solution' do
			assignment = Assignment.new
			assignment.solution_type = Assignment.LINK
			@solution.assignment = assignment
			expect(@solution.type).to eq Assignment.LINK
		end

	end
	
end
