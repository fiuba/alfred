#encoding: utf-8
require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
# Includes factories
Dir.glob(File.dirname(__FILE__) + "/../../spec/support/**/factory_*.rb").each { |f| require f }

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end

  def address_to( path )
    # Addresses files inside project_path/features/resources
    File.join( File.dirname(__FILE__), "..", "resources", "/", path )
  end

  def default_password
    "Passw0rd!"
  end

end
World(WithinHelpers)

#
# Courses' predicates
#
Given /^the course "(.*?)"$/ do |course_name|
  @course = Factories::Course.name( course_name )
end

Given /^the course with teacher and student enrolled$/ do
  step 'the course "2013-1"'
  step 'the teacher "John"'
  step 'the student "Richard"'
end

Given /^I enrole as student named "(.*?)"$/ do |student_name|
  fill_in(:account_name, :with => student_name)
  fill_in(:account_surname, :with => student_name + "Jr.")
  fill_in(:account_buid, :with => "77666" )
  fill_in(:account_email, :with => student_name.downcase + "@someplace.com" )
  fill_in(:account_tag, :with => "mie" )
  fill_in(:account_password, :with => default_password )
  fill_in(:account_password_confirmation, :with => default_password )
  click_button( "crear cuenta" )
end

#
# Account's predicates
#
Given /^the teacher "(.*?)"$/ do |teacher_name|
  @teacher = Factories::Account.teacher( teacher_name, "some_surname",
                "#{teacher_name}@someplace.com" )
  @teacher.buid = 'xxxx'
  @teacher.password = default_password
  @teacher.password_confirmation = default_password
  @teacher.courses << @course
  @teacher.save
end

Given /^the student "(.*?)"$/ do |student_name|
  @student = Factories::Account.student( student_name, "some_surname",
                "#{student_name}@someplace.com" )
  @student.buid = '77666'
  @student.password = default_password
  @student.password_confirmation = default_password
  @student.courses << @course
  @student.save
end

Then /^I log in as "(.*?)"$/ do |user_name|
  @account = Account.all( :name => user_name ).first
  visit '/login'
  fill_in(:email, :with => @account.email)
  fill_in(:password, :with => default_password)
  click_button :sign_in
end

Given /^I am logged in as student$/ do
  step 'I log in as "Richard"'
  @student = @account
end

Given /^I am logged in as teacher$/ do
  step 'I log in as "John"'
  @teacher = @account
end

Given /^I logged out$/ do
  visit '/logout'
  @account = nil
end

Then /^Log out menu option show be visible$/ do
  page.should have_content 'Salir'
end

When /^I edit my profile with name "(.*?)" and lastname "(.*?)" and tag "(.*?)"$/ do |name, lastname, tag|
  fill_in(:account_name, :with => name)
  fill_in(:account_surname, :with => lastname)
  fill_in(:account_tag, :with => tag)
  click_button 'Guardar'
end

When /^I edit my profile with password "(.*?)" and password confirmation "(.*?)"$/ do |password, password_confirmation|
  fill_in(:account_password, :with => password)
  fill_in(:account_password_confirmation, :with => password_confirmation)
  click_button 'Guardar'
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)
end

When /^I click "(.*?)"$/ do |button_or_link|
  click_on button_or_link
end

Then /^I should get file "(.*)"$/ do |file_name|
  page.status_code.should be 200
  page.response_headers["Content-Type"].should == "application/zip"
  page.response_headers["Content-Disposition"].should include("filename=#{file_name}")
end

Then(/^there should be (\d+) karma points$/) do |points|
  page.should have_content 'Karma: 1'
end

Then(/^I should see "(.*?)" on "(.*?)" for "(.*?)"$/) do |info, label, assignment|
  within("##{assignment.delete(' ')}") do
    within("##{label}") do
      page.should have_content info
    end
  end
end
