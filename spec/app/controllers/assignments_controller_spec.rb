require 'spec_helper'

describe "AssignmentsController" do
	before do
		teacher = Factories::Account.teacher
		Alfred::App.any_instance.stub(:current_account).and_return(teacher)
	end

	it "should_return_all_assignments_on_index" do
		course_double = double(:id => 202, :name => 'My Course')
		Course.should_receive(:first).any_number_of_times.and_return(course_double)
		Assignment.should_receive(:all).with({ :course =>  course_double }).and_return([ ])

		get '/courses/202/assignments'
	end

	it "should_create_a_new_assignment_and_retrieve_all_active_courses_on_new" do
		course_double = double(:id => 202, :name => 'My Course')
		Course.should_receive(:first).any_number_of_times.and_return(course_double)

	  get '/courses/202/assignments/new'
	end
end