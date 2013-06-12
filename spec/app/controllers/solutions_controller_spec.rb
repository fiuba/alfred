require 'spec_helper'

describe "SolutionsController" do
	
	it "should query Solutions" do
		Solution.should_receive(:all).and_return([])
		Alfred::App.any_instance.should_receive(:render).with('solutions/index').and_return({})
		get '/solutions'
	end

end