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

		describe "not logged in user" do
			before { visit '/solutions' }

			it "should redirects to login page" do
				should have_content( I18n.translate('padrino.admin.login.email') )
				should have_content( I18n.translate('padrino.admin.login.password') )
			end

			describe "once logged in" do
				before do
					login
				end

				it "should redirects to solutions" do
					Solution.all.each { |s| should have_content(s.file) }
				end
			end

		end

		describe "logged in user" do
			before do
				login
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

