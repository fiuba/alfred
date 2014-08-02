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
    let(:course)      { Factories::Course.algorithm }
    let(:student)     { Factories::Account.student }
    let(:assignment)  { Factories::Assignment.tp }

		describe 'solution_count' do

			it 'should return 0 when there are no solutions submitted' do
				student.status_for_assignment(assignment).solution_count.should eq 0
			end

			it 'should return 1 when there is a single solution submitted' do
				solution = Solution.new( :assignment => assignment )
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).solution_count.should eq 1
			end

			it 'should return the count of multiple solutions submitted by the student for that assignment' do
				solution1 = Solution.new( :assignment => assignment, :account => student )
				solution2 = Solution.new( :assignment => assignment, :account => student )
				Solution.should_receive(:all).and_return([ solution1, solution2 ])
				student.status_for_assignment(assignment).solution_count.should eq 2
			end

		end

		describe 'latest_solution_date' do

			it 'should return nil when there are no solutions submitted' do
				student.status_for_assignment(assignment).latest_solution_date.should eq nil
			end

			it 'should return the date of the latest solution submitted by the student for that assignment' do

				solution1 = Solution.new( :assignment => assignment )
				solution1.created_at = DateTime.now

				solution2 = Solution.new( :assignment => assignment )
				solution2.created_at = DateTime.now

				solution3 = Solution.new( :assignment => assignment )
				solution3.created_at = DateTime.now

				Solution.should_receive(:all).and_return([solution1, solution1, solution2, solution3])

				student.status_for_assignment(assignment).latest_solution_date.should eq solution3.created_at
			end


		end
		describe 'status' do

			it 'should return :solution_pending when there are no solutions submitted' do
				student.status_for_assignment(assignment).status.should eq :solution_pending
			end

			it 'should return :correction_pending when a solution was submitted but was not corrected yet' do
				solution = Solution.new( :assignment => assignment )
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_pending
			end

			it 'should return :correction_in_progress when a solution was submitted, a corrector was assigned but correction is not graded' do
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_in_progress)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_in_progress
			end

			it 'should return :correction_passed when a solution was submitted, corrected and passed' do
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_passed)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_passed
			end

			it 'should return :correction_passed when there are several solutions but at least one passed' do
				solution0 = Solution.new(:assignment => assignment)

				solution1 = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution1, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_failed)
				solution1.correction = correction

				solution2 = Solution.new(:assignment => assignment)
				correction2 = Correction.new(:solution => solution2, :teacher => teacher)
				correction2.should_receive(:status).and_return(:correction_passed)
				solution2.correction = correction2

				Solution.should_receive(:all).and_return([solution0, solution1, solution2])
				student.status_for_assignment(assignment).status.should eq :correction_passed
			end

			it 'should return :correction_failed when a solution was submitted, corrected and graded as failed' do
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_failed)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_failed
			end

			it 'should return :correction_failed when several solutions were submitted, corrected and failed' do
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_failed)
				solution.correction = correction

				solution1 = Solution.new(:assignment => assignment)
				correction1 = Correction.new(:solution => solution1, :teacher => teacher)
				correction1.should_receive(:status).and_return(:correction_failed)
				solution1.correction = correction1

				Solution.should_receive(:all).and_return([solution, solution1])
				student.status_for_assignment(assignment).status.should eq :correction_failed
			end

      describe "correction info" do
        let(:solution) { Factories::Solution.for(assignment) }
        let(:teacher) { Factories::Account.teacher }

        it "should not return neither grade nor teacher" do
				  student.status_for_assignment(assignment).grade.should be_nil
				  student.status_for_assignment(assignment).corrector_name.should be_nil
        end

        describe "with a correction" do
          let!(:correction) { Factories::Correction.correctsBy(solution, teacher) }

          it "should return both grading and teacher name" do
            status = student.status_for_assignment(assignment)
					  status.grade.should == 7.0
					  status.corrector_name.should == teacher.full_name
          end

          it "should return teacher name" do
            correction.grade = nil
            correction.save
            status = student.status_for_assignment(assignment)
            status.grade.should be_nil
					  status.corrector_name.should == teacher.full_name
          end
        end
      end
	  end
  end

  describe "create" do
    context 'admin' do
      let(:admin_attributes) { { :name => 'admin', :surname => 'admin', :buid => 'a', :email => 'admin@admin.com', :password => 'foobar', :password_confirmation => 'foobar', :role => Alfred::Admin::Account::ADMIN } }

      it "should allow creating admin account without tag" do
        admin = Account.new( admin_attributes )
        admin.should be_valid
      end

      it "should associate with all courses" do
        course1 = Course.new(name: 'Course 1', active: true)
        course1.save.should be_true
        course2 = Course.new(name: 'Course 2', active: false)
        course2.save.should be_true

        admin = Account.new( admin_attributes )

        admin.save.should be_true
        admin.courses.should include(course1)
        admin.courses.should include(course2)
      end
    end

    context 'teacher' do
      let(:teacher_attributes) { { :name => 'teacher', :surname => 'teacher', :buid => 'a', :email => 'teacher@teacher.com', :password => 'foobar', :password_confirmation => 'foobar', :role => Alfred::Admin::Account::TEACHER } }

      it "should associate with all courses" do
        course1 = Course.new(name: 'Course 1', active: true)
        course1.save.should be_true
        course2 = Course.new(name: 'Course 2', active: false)
        course2.save.should be_true

        teacher = Account.new( teacher_attributes )

        teacher.save.should be_true
        teacher.courses.should include(course1)
        teacher.courses.should include(course2)
      end
    end

    context 'student' do
      let(:student_attributes) { { :name => 'Yoda', :surname => '?', :buid => 'y', :email => 'yoda@student.com', :password => 'foobar', :password_confirmation => 'foobar', :role => Alfred::Admin::Account::STUDENT, :tag => Account.valid_tags.first } }

      it "should allow creating student with valid tag" do
        student = Account.new( student_attributes )

        student.should be_valid
      end

      it "should associate only with active course" do
        course1 = Course.new(name: 'Course 1', active: true)
        course1.save.should be_true
        course2 = Course.new(name: 'Course 2', active: false)
        course2.save.should be_true

        student = Account.new( student_attributes )

        student.save.should be_true
        student.courses.should include course1
      end
    end
  end

  describe 'update password' do
    let(:account) { Factories::Account.teacher }
    let(:new_password) { 'my_new_password' }

    it "should update password if other attributes updated" do
      account.password = new_password
      account.password_confirmation = new_password
      account.name = 'ANewName'

      account.save.should be_true

      authenticated_account = Account.authenticate(account.email, new_password)

      authenticated_account.should eq(account)
    end

    it "should update password if only attribute updated" do
      account.password = new_password
      account.password_confirmation = new_password

      account.save.should be_true

      authenticated_account = Account.authenticate(account.email, new_password)

      authenticated_account.should eq(account)
    end
  end
end
