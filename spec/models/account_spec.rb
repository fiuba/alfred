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

end
