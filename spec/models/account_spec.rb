require 'spec_helper'

describe Account do

	describe 'is_student?' do

		it 'should return true when is student' do
			student = Account.new_student( {:name => 'student name'})
			student.is_student?.should be true
		end


		it 'should return false when is teacher' do
			student = Account.new_teacher( {:name => 'teacher name'})
			student.is_student?.should be false
		end

	end

		describe 'is_teacher?' do

		it 'should return false when is student' do
			student = Account.new_student( {:name => 'student name'})
			student.is_teacher?.should be false
		end


		it 'should return true when is teacher' do
			account = Account.new_teacher( {:name => 'teacher name'})
			account.is_teacher?.should be true
		end

	end

	describe 'status_for_assignment' do

		it 'should return :solution_pending when there are no solutions submitted' do
			pending
		end

		it 'should return :correction_pending when when a solution was submitted but was not corrected yet' do
			pending
		end

		it 'should return :approved when a solution was submitted, corrected and graded as passed' do
			pending
		end

		it 'should return :failed when a solution was submitted, corrected and graded as failed' do
			pending
		end

	end
	
end
