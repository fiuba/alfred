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
  fill_in(:account_password, :with => "foobar" )
  fill_in(:account_password_confirmation, :with => "foobar" )
  click_button( "crear cuenta" )
end

# 
# Account's predicates 
#
Given /^the teacher "(.*?)"$/ do |teacher_name|
  @teacher = Factories::Account.teacher( teacher_name, "some_surname", 
                "#{teacher_name}@someplace.com" )
  @teacher.buid = 'xxxx'
  @teacher.password = 'Passw0rd!'
  @teacher.password_confirmation = 'Passw0rd!'
  @teacher.courses << @course
  @teacher.save
end

Given /^the student "(.*?)"$/ do |student_name|
  @student = Factories::Account.student( student_name, "some_surname", 
                "#{student_name}@someplace.com" )
  @student.buid = '77666'
  @student.password = 'Passw0rd!'
  @student.password_confirmation = 'Passw0rd!'
  @student.courses << @course
  @student.save
end

Then /^I log in as "(.*?)"$/ do |student_name|
  student = Account.all( :name => student_name ).first
  fill_in(:email, :with => student.email)
  fill_in(:password, :with => 'foobar')
  click_button :sign_in
end

Given /^I am logged in as student$/ do
  @account = @student
  visit '/login'
  fill_in(:email, :with => @student.email)
  fill_in(:password, :with => 'Passw0rd!')
  click_button :sign_in
end

Given /^I am logged in as teacher$/ do
  @account = @teacher
  visit '/login'
  fill_in(:email, :with => @teacher.email)
  fill_in(:password, :with => 'Passw0rd!')
  click_button :sign_in
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

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)
end

