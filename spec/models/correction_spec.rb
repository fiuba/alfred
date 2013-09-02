require 'spec_helper'

describe Correction do

  let(:assignment) { Factories::Assignment.vending_machine }
	let(:teacher) { Factories::Account.teacher }
	let(:solution) { Factories::Solution.for(assignment) }
  let(:student) { solution.account }

	before (:each) do
		DataMapper.auto_migrate!
    @correction = Correction.new(
      :teacher => teacher,
      :solution => solution,
      :public_comments => "public comment",
      :private_comments => "private comment",
      :grade => 10
    )
	end

	subject { @correction }

	it { should respond_to( :solution ) }
	it { should respond_to( :teacher ) }
	it { should respond_to( :public_comments ) }
	it { should respond_to( :private_comments ) }
	it { should respond_to( :grade ) }


  describe "creation" do
      before do
        @correction = Correction.new(
          :teacher => Factories::Account.teacher( "Yoda", "yoda@d.com"),
          :solution => solution,
          :public_comments => "public comment",
          :private_comments => "private comment",
          :grade => 9
        )
        @correction.save
      end

      it "should have creating date equal to today" do
        @correction.created_at.to_date.should == Date.today
      end
  end

  describe "invalid" do

    describe "duplicated correction" do
      before do
        @correction.save
        @duplicated_correction = Correction.new(
          :teacher => Factories::Account.teacher( "Yoda", "yoda@d.com"),
          :solution => solution,
          :public_comments => "public comment",
          :private_comments => "private comment",
          :grade => 9
        )
      end
      it "should not be both corrections with the same teacher and solution" do
        @duplicated_correction.should_not be_valid
      end
    end

    describe "not valid without teacher" do
      before  { @correction.teacher = Factories::Account.student }
      it      { should_not be_valid }
    end

    describe "not valid with a grade out of range" do
      it "should not be valid with a grade of 11" do
        @correction.grade = 11
        @correction.should_not be_valid
      end

      it "should not be valid with a grade of -1" do
        @correction.grade = -1
        @correction.should_not be_valid
      end
    end

    describe "not valid without solution" do
      before  { @correction.solution = nil }
      it      { should_not be_valid }
    end

    describe "not valid without teacher" do
      before  { @correction.teacher = nil }
      it      { @correction.should_not be_valid }
    end
  end

  describe "valid" do
    it { should be_valid }

		it "should have the right teacher and solution" do
			@correction.teacher.should == teacher
			@correction.solution.should == solution
		end

    describe "without grade" do
      it "should save a correction with nil grade" do
        @correction.grade = nil
        @correction.should be_valid
      end
    end

    describe "not duplicated correction" do
      before do
        @correction.save
        other_solution = Factories::Solution.forBy( assignment,
          Factories::Account.student("Luck", "luck@d.com") )
        @another_correction = Correction.new(
          :teacher => teacher,
          :solution => other_solution,
          :public_comments => "public comment",
          :private_comments => "private comment",
          :grade => 9
        )
      end

      it "should be allowed corrections with different teacher and solution" do
        @another_correction.should be_valid
      end
    end

  end

  describe 'approved?' do

    it 'should return false when grade is not defined' do
      correction = Correction.new
      correction.approved?.should be_false
    end

    it 'should return false when grade is less than 4' do
      correction = Correction.new
      correction.grade = 2
      correction.approved?.should be_false
    end

    it 'should return true when grade is 4' do
      correction = Correction.new
      correction.grade = 4
      correction.approved?.should be_true
    end

    it 'should return true when grade is greater then 4' do
      correction = Correction.new
      correction.grade = 5
      correction.approved?.should be_true
    end
  end

  describe 'status' do

    it 'should return :correction_in_progress when grade is not set' do
      @correction.grade = nil
      @correction.status.should eq :correction_in_progress
    end

    it 'should return  :correction_failed when grade is set and less than 4' do
      @correction.grade = 1
      @correction.status.should eq :correction_failed
    end

    it 'should return  :correction_passed when grade is set and greated than 4' do
      @correction.grade = 7
      @correction.status.should eq :correction_passed
    end
  end

  describe 'assigned_corrections_status' do

    it "should retrieve single assigned correction" do
      Factories::Correction.correctsBy(solution, teacher)

      status_for_assignments = Correction.assigned_corrections_status(teacher)

      status_for_assignments.count.should == 1
      status_for_assignments[0][:assignment_status].assignment_id.should == assignment.id
      status_for_assignments[0][:assignment_status].corrector_name.should == teacher.full_name
      status_for_assignments[0][:student].should == student
    end

    it "should retrieve single assigned correction for student with multiple solutions for same assignment" do
      Factories::Correction.correctsBy(solution, teacher)
      solution2 = Factories::Solution.forBy(assignment, student)
      Factories::Correction.correctsBy(solution2, teacher)

      status_for_assignments = Correction.assigned_corrections_status(teacher)

      status_for_assignments.count.should == 1
      status_for_assignments[0][:assignment_status].assignment_id.should == assignment.id
      status_for_assignments[0][:assignment_status].corrector_name.should == teacher.full_name
      status_for_assignments[0][:student].should == student
    end

    it "should retrieve multiple assigned corrections for multiple students" do
      Factories::Correction.correctsBy(solution, teacher)
      student2 = Factories::Account.student('John', 'Doe', 'john@example.com', 'B')
      solution2 = Factories::Solution.forBy(assignment, student2)
      Factories::Correction.correctsBy(solution2, teacher)

      status_for_assignments = Correction.assigned_corrections_status(teacher)

      status_for_assignments.count.should == 2
      status_for_assignments.each do |sfa|
        sfa[:assignment_status].assignment_id.should == assignment.id
        sfa[:assignment_status].corrector_name.should == teacher.full_name
      end
      status_for_assignments.collect {|sfa| sfa[:student] }.should include(student)
      status_for_assignments.collect {|sfa| sfa[:student] }.should include(student2)
    end

    it "should retrieve multiple assigned corrections for student with multiple assignments" do
      Factories::Correction.correctsBy(solution, teacher)
      assignment2 = Factories::Assignment.vending_machine
      solution2 = Factories::Solution.forBy(assignment2, student)
      Factories::Correction.correctsBy(solution2, teacher)

      status_for_assignments = Correction.assigned_corrections_status(teacher)

      status_for_assignments.count.should == 2
      status_for_assignments.each do |sfa|
        [assignment.id, assignment2.id].should include(sfa[:assignment_status].assignment_id)
        sfa[:assignment_status].corrector_name.should == teacher.full_name
        sfa[:student].should == student
      end
    end

    it "should retrieve multiple assigned corrections for multiple students with multiple assignments and multiple solutions" do
      Factories::Correction.correctsBy(solution, teacher)
      solution2 = Factories::Solution.forBy(assignment, student)
      Factories::Correction.correctsBy(solution2, teacher)
      assignment2 = Factories::Assignment.vending_machine
      solution3 = Factories::Solution.forBy(assignment2, student)
      Factories::Correction.correctsBy(solution3, teacher)
      student2 = Factories::Account.student('John', 'Doe', 'john@example.com', 'B')
      solution4 = Factories::Solution.forBy(assignment, student2)
      Factories::Correction.correctsBy(solution4, teacher)

      status_for_assignments = Correction.assigned_corrections_status(teacher)

      status_for_assignments.count.should == 3
      status_for_assignments.each do |sfa|
        [assignment.id, assignment2.id].should include(sfa[:assignment_status].assignment_id)
        sfa[:assignment_status].corrector_name.should == teacher.full_name
      end

      assigned_students = status_for_assignments.inject([]) do |ss, sfa|
        ss << sfa[:student] unless ss.include?(sfa[:student])
        ss
      end
      assigned_students.count.should == 2
      assigned_students.should include(student)
      assigned_students.should include(student2)
    end
  end
end
