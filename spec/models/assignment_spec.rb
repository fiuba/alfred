require 'spec_helper'

describe Assignment do

	subject { Assignment.new }

  it { should respond_to( :course ) }
  it { should respond_to( :assignment_file ) }
  it { should respond_to( :solutions ) }
  it { should respond_to( :name ) }
  it { should respond_to( :deadline ) }
  it { should respond_to( :test_script ) }
  it { should respond_to( :is_optional ) }
  it { should respond_to( :is_blocking ) }
  it { should respond_to( :solution_type ) }
  it { should respond_to( :correction_template ) }

  describe 'initialize' do
    
    it 'is_optional should be false' do
      subject.is_optional.should be_false
    end
    
  end

end
