require 'spec_helper'

describe "AssignmentsController" do
	it "should_return_all_assignments_on_index" do
		Assignment.should_receive(:all).and_return([ ])

		get '/assignments'
	end

	it "should_create_a_new_assignment_and_retrieve_all_active_courses_on_new" do
	  Course.should_receive(:all).with(:active => true)

	  get '/assignments/new'
	end
end