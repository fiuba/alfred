require 'spec_helper'

describe "SolutionsController" do

	before (:all) do 
		DataMapper.auto_migrate!
		account = Account.create( :email => "x@x.com", 
								:password => "foobar",
								:password_confirmation => "foobar",
								:role => "student", :buid => "?"	)

	 	course = Course.create( :name => "AlgoIII", :active => true )
		assignment = Assignment.create( :course => course )

		# Creates several solutions
		('solution_1'..'solution_8').each do |s| 
			Solution.create!( :file => s, :assignment => assignment, 
											:account => account )

		end
	end

	describe "/solutions" do
		subject { page }

		describe "logged in user" do
			before do
				visit '/login' 
				fill_in :email, :with => "x@x.com"
				fill_in :password, :with => "foobar"
				click_button('Sign In')
			end


			describe "when user requests index" do
				before { visit '/solutions' }

				it "should responses solutions already handed in" do
					Solution.all.each { |s| should have_content(s.file) }
				end
			end
		end
	end
end
