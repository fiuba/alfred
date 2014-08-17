require 'spec_helper'

describe Assignment do

  before (:each) do
    @assignment = Assignment.new
  end

	subject { @assignment }

  it { should respond_to( :course ) }
  it { should respond_to( :assignment_file ) }
  it { should respond_to( :solutions ) }
  it { should respond_to( :name ) }
  it { should respond_to( :deadline ) }
  it { should respond_to( :test_script ) }
  it { should respond_to( :is_auto_grading ) }

  describe 'initialize' do
    
    it 'is_auto_grading should be false' do
      @assignment.is_auto_grading.should be_false
    end
    
  end

end
