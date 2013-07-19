require 'spec_helper'

describe Correction do

	before (:each) do
		DataMapper.auto_migrate!
    assignment = Factories::Assignment.vending_machine
    @solution = Factories::Solution.for( assignment )
    @correction = Correction.new(
      :teacher => Factories::Account.teacher,
      :solution => @solution,
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


  describe "invalid" do

    describe "duplicated correction" do
      before do
        @correction.save
        @duplicated_correction = Correction.new(
          :teacher => Factories::Account.teacher,
          :solution => @solution,
          :public_comments => "public comment",
          :private_comments => "private comment",
          :grade => 9
        )
      end 
      it "should not be both corrections with the same teacher and solution" do
        @duplicated_correction.should_not be_valid 
      end
    end

    describe "should not be valid if not a teacher ranks" do
      before  { @correction.teacher = Factories::Account.student }
      it      { should_not be_valid }
    end

    describe "should not be valid with a grade out of range" do
      it "should not be valid with a grade of 11" do
        @correction.grade = 11
        @correction.should_not be_valid
      end

      it "should not be valid with a grade of -1" do
        @correction.grade = -1
        @correction.should_not be_valid
      end
    end

    describe "should not be valid without grade" do
      before  { @correction.grade = nil }
      it      { should_not be_valid }
    end

    describe "should not be valid without private comment" do
      before  { @correction.public_comments = nil }
      it      { should_not be_valid }
    end

    describe "should not be valid without public comment" do
      before  { @correction.public_comments = nil }
      it      { should_not be_valid }
    end

    describe "should not be valid without solution" do
      before  { @correction.solution = nil }
      it      { should_not be_valid }
    end

    describe "should not be valid without solution" do
      before  { @correction.teacher = nil }
      it      { @correction.should_not be_valid }
    end
  end

  describe "valid" do 
    it { should be_valid }

    describe "not duplicated correction" do
      before do
        @correction.save
        @another_correction = Correction.new(
          :teacher => Factories::Account.teacher( "Yoda", "yoda@d.com"),
          :solution => @solution,
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

end