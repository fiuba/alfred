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

  # Responses DOM object
  def as_teacher_for_assignment( assignment_name, action )
    query = "" <<                                                                          \
      "//table[@id='assigmentsGrid']" <<                                                   \
      "/tbody/tr" <<                                                                       \
      "/td[starts-with(normalize-space(.), '#{assignment_name}')]" <<                      \
      "/.." <<                                                                             \
      "/td[starts-with( normalize-space(@class), 'list-column list-row-action')]/div" <<   \
      "/a[starts-with(normalize-space(@title), '#{action}')]"
    find(:xpath, query)
  end

  def as_student_for_assignment( assignment_name, action )
    query = "" <<                                                                           \
      "//table[@id='studentsGrid']"                                                         \
      "/tbody/tr/td[starts-with(normalize-space(.), '#{assignment_name}')]"                 \
      "/../td/a[starts-with(normalize-space(@title), '#{action}')]"
    find(:xpath, query)
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

Given /^I am logged in as student$/ do
  visit '/login'
  fill_in(:email, :with => @student.email)
  fill_in(:password, :with => 'Passw0rd!')
  click_button :sign_in
end

Given /^I am logged in as teacher$/ do
  visit '/login'
  fill_in(:email, :with => @teacher.email)
  fill_in(:password, :with => 'Passw0rd!')
  click_button :sign_in
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

# 
# Solution's predicate
#
When /^I click submit solution for "(.*?)"$/ do |assignment_name|
  as_student_for_assignment( assignment_name, 'Entregar solución' ).click
end

When /^I upload the solution's file for "(.*?)"$/ do |assignment_name|
  VCR.use_cassette("cassette_solution_for_#{assignment_name.downcase}") do
    attach_file(:solution_file, address_to("#{@student.buid}.zip"))
    click_button( "Guardar" )
  end
end

# 
# Assignment's predicate
#
When /^I fill requeried data for assignment entitled "(.*?)"$/ do |assignment_name|
  VCR.use_cassette("cassette_assignment_#{assignment_name.downcase}") do
    with_scope( '.form-horizontal' ) do
      fill_in( :assignment_name,        :with => assignment_name)
      fill_in( :assignment_deadline,    :with => "20/10/2013")
      fill_in( :assignment_test_script, :with => "#!/bin/bash\necho $?")
      attach_file(:assignment_file, address_to("#{assignment_name.downcase}.zip"))
      click_button( "Guardar y continuar" )
    end
  end
end

When /^I click edit button edit on "(.*?)"$/ do |assignment_name|
  as_teacher_for_assignment( assignment_name, 'Editar trabajo práctico').click
end

When  /^I click download assignment file button for "(.*?)"$/ do |assignment_name|
  VCR.use_cassette("cassette_assignment_download_#{assignment_name.downcase}") do
    as_teacher_for_assignment( assignment_name, 'Bajar archivo').click
  end
end

When /^I update data intended to be updated for assignment "(.*?)"$/ do |assignment_name|
  with_scope( '.form-horizontal' ) do
    fill_in( :assignment_deadline,    :with => "22/10/2013")
    fill_in( :assignment_test_script, :with => "")
    click_button( "Guardar y continuar" )
  end
end

And /^The assignment entitled "(.*?)" should be properly updated$/ do |assignment_name|
  assignment = Assignment.all( :name => assignment_name ).first
  assignment.deadline.should == "22/10/2013".to_date
  assignment.name.should == assignment_name
end

Given /^the assignment entitled "(.*?)"$/ do |assignment_name|
  @assignment = Factories::Assignment.name( assignment_name, @course )
  @assignment.deadline = Date.today()
  @assignment.save
end

Given /^there is a bunch of assignment already created$/ do
  step 'I am logged in as teacher'
  step 'I follow "Trabajos prácticos"'
  (0..2).each do |n|
    step 'I follow "Nuevo"'
    step "I fill requeried data for assignment entitled \"TP#{n}\""
  end
end

Then /^I should get the file$/ do 
  page.status_code.should be 200
end
