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
				Solution.should_receive(:find_by_account_and_assignment).and_return(solution)
				student.status_for_assignment(assignment).solution_count.should eq 1
			end

			it 'should return the count of multiple solutions submitted by the student for that assignment' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution1 = Solution.new( :assignment => assignment, :account => student )
				solution2 = Solution.new( :assignment => assignment, :account => student )
				Solution.should_receive(:find_by_account_and_assignment).and_return([ solution1, solution2 ])
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

				Solution.should_receive(:find_by_account_and_assignment).and_return([solution1, solution1, solution2, solution3])

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
				Solution.should_receive(:find_by_account_and_assignment).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_pending
			end

			it 'should return :correction_in_progress when a solution was submitted, a corrector was assigned but correction is not graded' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				correction = Correction.new(:solution => solution)
				correction.should_receive(:approved?).and_return(false)
				correction.should_receive(:grade).and_return(nil)
				solution.correction = correction
				Solution.should_receive(:find_by_account_and_assignment).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_in_progress
			end

			it 'should return :correction_passed when a solution was submitted, corrected and graded as passed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				correction = Correction.new(:solution => solution)
				correction.should_receive(:approved?).and_return(true)
				solution.correction = correction
				Solution.should_receive(:find_by_account_and_assignment).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_passed
			end

			it 'should return :correction_passed when there are several solutions but at least one corrected and graded as passed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution0 = Solution.new(:assignment => assignment)

				solution1 = Solution.new(:assignment => assignment)
				correction = Correction.new(:solution => solution1)
				correction.should_receive(:approved?).and_return(false)
				solution1.correction = correction

				solution2 = Solution.new(:assignment => assignment)
				correction2 = Correction.new(:solution => solution2)
				correction2.should_receive(:approved?).and_return(true)
				solution2.correction = correction2

				Solution.should_receive(:find_by_account_and_assignment).and_return([solution0, solution1, solution2])
				student.status_for_assignment(assignment).status.should eq :correction_passed
			end

			it 'should return :correction_failed when a solution was submitted, corrected and graded as failed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				correction = Correction.new(:solution => solution)
				correction.should_receive(:approved?).and_return(false)
				correction.should_receive(:grade).and_return(2)
				solution.correction = correction
				Solution.should_receive(:find_by_account_and_assignment).and_return([solution])
				student.status_for_assignment(assignment).status.should eq :correction_failed
			end

			it 'should return :correction_failed when several solutions were submitted, corrected and graded as failed' do
				course = Course.new( :name => "AlgoIII", :active => true )
				student = Account.new( :email => "x@x.com", :role => "student", :buid => "?")
				assignment = Assignment.new( :course => course )
				solution = Solution.new(:assignment => assignment)
				correction = Correction.new(:solution => solution)
				correction.should_receive(:approved?).and_return(false)
				correction.should_receive(:grade).and_return(2)
				solution.correction = correction

				solution1 = Solution.new(:assignment => assignment)
				correction1 = Correction.new(:solution => solution1)
				correction1.should_receive(:approved?).and_return(false)
				correction1.should_receive(:grade).and_return(2)
				solution1.correction = correction1

				Solution.should_receive(:find_by_account_and_assignment).and_return([solution, solution1])
				student.status_for_assignment(assignment).status.should eq :correction_failed
			end
		end
		
	end
	
end
