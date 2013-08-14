require 'spec_helper'

describe "TeacherController" do
  let(:teacher) { Factories::Account.teacher }
  let(:algorithm) { Factories::Course.algorithm }
  let(:vending_machine) { Factories::Assignment.vending_machine }
  let(:solution) { Factories::Solution.for( vending_machine) }

  before (:each) do
    Alfred::App.any_instance.stub(:current_account).and_return(teacher)
  end

  describe "gradings" do
    it "should response a list of correction to a assignment" do
      get "/assignments/#{vending_machine.id}/gradings"
      last_response.status.should == 200
    end
  end
end
