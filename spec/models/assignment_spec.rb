require 'spec_helper'

describe Assignment do
	subject { Factories::Assignment.withSolution }

	it "should not destroy if has solutions" do
	  subject.destroy.should be_false
	end
end
