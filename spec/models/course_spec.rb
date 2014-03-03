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

    it "should force active course if none is active on save" do
      course = Course.new(name: 'my course', active: false)

      course.save.should be_true

      course.active.should be_true
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

  describe '#create' do
    [:admin, :teacher].each do |role|
      eval <<-SPEC
        it "should associate with all #{role}s" do
          #{role}1 = Factories::Account.#{role}('#{role}', 'One', '#{role}1@example.com', '12345')
          #{role}2 = Factories::Account.#{role}('#{role}', 'Two', '#{role}2@example.com', '67890')

          #{role}1.courses.should be_empty
          #{role}2.courses.should be_empty

          course = Course.new
          course.save

          #{role}1.reload
          #{role}1.courses.should include course
          #{role}2.reload
          #{role}2.courses.should include course
        end
      SPEC
    end

    it "should not associate with students" do
      student = Factories::Account.student('Student', 'One', 'student1@example.com', '12345', [])
      student.courses.should be_empty

      course = Course.new
      course.save

      student.reload
      student.courses.should be_empty
    end
  end
end
