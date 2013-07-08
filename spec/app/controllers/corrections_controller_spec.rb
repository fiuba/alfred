require 'spec_helper'

describe "CorrectionsController" do
 
	describe "index" do
		it "should respond with error 403 whether not a teacher access to" do
			teacher = Factories::Account.student
			get "/corrections/#{teacher.id}"
			last_response.status.should == 403
		end

		it "should render index content" do
			teacher = Factories::Account.teacher
			Correction.should_receive(:all)
				.with(:teacher => teacher)
				.and_return([])
			Alfred::App.any_instance.should_receive(:render)
				.with('corrections/index').and_return({})
			get "/corrections/#{teacher.id}"
		end
	end
end
