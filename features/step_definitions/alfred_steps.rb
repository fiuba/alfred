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

When /^I fill requeried data for assignment entitled "(.*?)"$/ do |assignment_title|
  VCR.use_cassette(:cassette_assignment_new) do
    with_scope( '.form-horizontal' ) do
      fill_in( :assignment_name,        :with => assignment_title)
      fill_in( :assignment_deadline,    :with => "20/10/2013")
      fill_in( :assignment_test_script, :with => "#!/bin/bash\necho $?")
      attach_file(:assignment_file, address_to("tp0.zip"))
      click_button( "Guardar y continuar" )
    end
  end
end

Given(/^the course "(.*?)"$/) do |course_name|
  @course = Factories::Course.name( course_name )
end

Given(/^the teacher "(.*?)"$/) do |teacher_name|
  @account = Factories::Account.teacher( teacher_name, "some_surname", 
                "#{teacher_name}@someplace.com" )
  @account.buid = 'xxxx'
  @account.password = 'Passw0rd!'
  @account.password_confirmation = 'Passw0rd!'
  @account.courses << @course
  @account.save
end

Given(/^I am logged in as teacher$/) do
  visit '/login'
  fill_in(:email, :with => @account.email)
  fill_in(:password, :with => 'Passw0rd!')
  click_button :sign_in
end

Then(/^Log out menu option show be visible$/) do
  page.should have_content 'Salir'
end

When(/^I edit my profile with name "(.*?)" and lastname "(.*?)" and tag "(.*?)"$/) do |name, lastname, tag|
  fill_in(:account_name, :with => name)
  fill_in(:account_surname, :with => lastname)
  fill_in(:account_tag, :with => tag)
  click_button 'Guardar'
end

When /^I follow "([^\"]*)"$/ do |link|
  click_link(link)
end

