require 'spec_helper'

describe Course do

  describe 'active' do
    it "should allow a single course to be active at any time" do
      course1 = Course.new(name: 'course 1', active: true)
      course1.save.should be_true

      course2 = Course.new(name: 'course 2', active: true)
      course2.save.should be_true

      course2.active.should be_true
      course1.reload
      course1.active.should be_false
    end
  end

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
