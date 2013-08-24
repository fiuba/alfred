require 'spec_helper'

describe Course do

	describe 'students' do

		it 'should query accounts with role student' do
			course = Course.new 
			accounts = []
			student = Account.new_student(:name => 'student name')
			teacher = Account.new_teacher(:name => 'teacher name')
			course.should_receive(:accounts).and_return([student, teacher])
			course.students.size.should eq 1
		end
		
	end
end
