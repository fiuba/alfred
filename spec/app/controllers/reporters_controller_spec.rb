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
    describe "student tries to download gradings" do
      it "should response not 200" do
        Alfred::App.any_instance.stub(:current_account).and_return(solution.account)
        get "/assignments/#{vending_machine.id}/gradings_report"
        last_response.status.should_not == 200
      end
    end

    it "should response 404 if assignment does not exist" do
      get "/assignments/9999/gradings_report"
      last_response.status.should == 404
    end

    it "should response a list of correction to a assignment" do
      expected_content_disposition = "attachment; filename=" +
        "#{GradingReport.file_name(vending_machine)}"
      GradingReport.should_receive(:report).with(vending_machine)
      get "/assignments/#{vending_machine.id}/gradings_report"
      last_response.status.should == 200
      last_response.headers['Content-Disposition'].should == expected_content_disposition
    end
  end
end
