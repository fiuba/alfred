require 'uri'
require 'cgi'
require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))
#require_relative '../../models/course.rb'
# Includes factories
#Dir.glob(File.dirname(__FILE__) + "/../../spec/support/**/factory_*.rb").each { |f| require f }

module WithinHelpers
  def with_scope(locator)
    locator ? within(locator) { yield } : yield
  end
end
World(WithinHelpers)


Given(/^the course "(.*?)"$/) do |course_name|
  @course = Course.new
  @course.name = course_name
  @course.save
end

Given(/^the teacher "(.*?)"$/) do |teacher_name|
  @account = Account.new_teacher( {:name => teacher_name,
    :surname => "some_surname",
    :email => "#{teacher_name}@someplace.com",
    :buid => 'xxxx',
    :password => 'Passw0rd!',
    :password_confirmation => 'Passw0rd!'})
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
