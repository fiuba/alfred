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

		describe 'solution_count' do

			it 'should return 0 when there are no solutions submitted' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				student.status_for_assignment(assignment).solution_count.should eq 0
			end

			it 'should return 1 when there is a single solution submitted' do
			  course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new( :assignment => assignment )
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).solution_count.should eq 1
			end

			it 'should return the count of multiple solutions submitted by the student for that assignment' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution1 = Solution.new( :assignment => assignment, :account => student )
				solution2 = Solution.new( :assignment => assignment, :account => student )
				Solution.should_receive(:all).and_return([ solution1, solution2 ])
				student.status_for_assignment(assignment).solution_count.should eq 2
			end

		end

		describe 'latest_solution_date' do

			it 'should return nil when there are no solutions submitted' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				student.status_for_assignment(assignment).latest_solution_date.should eq nil
			end

			it 'should return the date of the latest solution submitted by the student for that assignment' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )

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
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				student.status_for_assignment(assignment).status.should eq :solution_pending
			end

			it 'should return :correction_pending when a solution was submitted but was not corrected yet' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new( :assignment => assignment )
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_pending
			end

			it 'should return :correction_in_progress when a solution was submitted, a corrector was assigned but correction is not graded' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_in_progress)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_in_progress
			end

			it 'should return :correction_passed when a solution was submitted, corrected and passed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_passed)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_passed
			end

			it 'should return :correction_passed when there are several solutions but at least one passed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
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
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				teacher = Account.new
				correction = Correction.new(:solution => solution, :teacher => teacher)
				correction.should_receive(:status).and_return(:correction_failed)
				solution.correction = correction
				Solution.should_receive(:all).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_failed
			end

			it 'should return :correction_failed when several solutions were submitted, corrected and failed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
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
	  end
  end

  describe "create" do
    it "should allow creating admin account without tag" do
      params = {
        :name => 'admin',
        :surname => 'admin',
        :buid => 'a',
        :email => 'admin@admin.com',
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::ADMIN
      }

      admin = Account.new( params )
      admin.should be_valid
    end

    it "should allow creating student with valid tag" do
      params = {
        :name => 'Yoda',
        :surname => '?',
        :buid => 'y',
        :email => 'yoda@student.com',
        :password => 'foobar',
        :password_confirmation => 'foobar',
        :role => Alfred::Admin::Account::STUDENT,
        :tag => Account.valid_tags.first
      }

      yoda = Account.new( params )
      yoda.should be_valid
    end
  end
end
