#encoding: utf-8
#
module AssignmentHelpers
  # Responses DOM object
  def as_teacher_for_assignment( assignment_name, action )
    query = "" <<                                                                          \
      "//td[starts-with(normalize-space(.), '#{assignment_name}')]" <<                     \
      "/.." <<                                                                             \
      "/td//" << \
      "a[starts-with(normalize-space(@title), '#{action}')]"                           
    find(:xpath, query)
  end

  def as_student_for_assignment( assignment_name, action )
    query = "" <<                                                             \
      "//td[starts-with(normalize-space(.), '#{assignment_name}')]"           \
      "/.." <<  \
      "/td/a[starts-with(normalize-space(@title), '#{action}')]"
    find(:xpath, query)
  end
end
World(AssignmentHelpers)

When /^I fill required data for assignment entitled "(.*?)"$/ do |assignment_name|
  @assignment_date = Date.today + 2
  step "I fill required data for non blocking assignment \"#{assignment_name}\" due to \"#{@assignment_date}\""
end

When /^I fill required data for assignment "(.*?)" to be delivered as "(.*?)"$/ do |assignment_name, solution_type|
  @assignment_date = Date.today + 2
  step "I fill data for non blocking assignment \"#{assignment_name}\" due to \"#{@assignment_date}\" to be delivered as \"#{solution_type}\""
end

When /^I fill required data for (non )?blocking assignment "(.*?)" due to "(.*?)"$/ do |blocking, assignment_name, date|
  step "I fill data for #{blocking}blocking assignment \"#{assignment_name}\" due to \"#{date}\" to be delivered as \"file\""
end

When /^I fill data for (non )?blocking assignment "(.*?)" due to "(.*?)" to be delivered as "(.*?)"?$/ do |blocking, assignment_name, date, solution_type|
  @assignment_date = date == 'today' ? Date.today : date
  type = solution_type(solution_type)
  VCR.use_cassette("cassette_assignment_#{assignment_name.downcase}") do
    with_scope( '.form-horizontal' ) do
      fill_in( :assignment_name,        :with => assignment_name)
      fill_in( :assignment_deadline,    :with => @assignment_date)
      if blocking != 'non '
        check(:assignment_is_blocking)
      end
      select(solution_type)
      fill_in( :assignment_test_script, :with => "#!/bin/bash\necho $?")
      attach_file(:assignment_file, address_to("#{assignment_name.downcase}.zip"))
      step 'I click "Guardar y continuar"'
    end
  end
end

When /^I click edit button edit on "(.*?)"$/ do |assignment_name|
  as_teacher_for_assignment( assignment_name, 'Editar trabajo práctico').click
end

And /^I follow "(.*)" for "(.*?)"$/ do |action_name, assignment_name|
  as_teacher_for_assignment( assignment_name, action_name).click
end

When /^I click download assignment file button for "(.*?)"$/ do |assignment_name|
  action = { 
    'teacher' => Proc.new { as_teacher_for_assignment( assignment_name, \
        'Bajar archivo').click 
    },
    'student' => Proc.new { as_student_for_assignment( assignment_name, \
        'Bajar archivo').click 
    }
  }
  VCR.use_cassette("cassette_assignment_download_#{assignment_name.downcase}") do
    action[@account.role].call
  end
end

When /^I update data intended to be updated for assignment "(.*?)"$/ do |assignment_name|
  step "I update data with new date \"#{Date.today + 2}\" intended to be updated for assignment \"#{assignment_name}\""
end

When /^I update data with new date "(.*?)" intended to be updated for assignment "(.*?)"$/ do |date, assignment_name|
  @assignment_date = date == 'today' ? Date.today : date.to_date
  with_scope( '.form-horizontal' ) do
    fill_in( :assignment_deadline,    :with => @assignment_date)
    fill_in( :assignment_test_script, :with => "")
    step 'I click "Guardar y continuar"'
  end
end

And /^The assignment entitled "(.*?)" should (not )?be (properly )?updated$/ do |assignment_name, s_not, _|
  assignment = Assignment.all( :name => assignment_name ).first
  expect(assignment.deadline == @assignment_date).to be (s_not != 'not ')
  assignment.name.should == assignment_name
end

Given /^the assignment entitled "(.*?)"$/ do |assignment_name|
  @assignment = Factories::Assignment.name( assignment_name, @course )
  @assignment_date = Date.today() + 2
  @assignment.deadline = @assignment_date.to_s
  @assignment.save
end

Given /^there is a bunch of assignment already created$/ do
  step 'I am logged in as teacher'
  step 'I follow "Trabajos prácticos"'
  (0..1).each do |n|
    step 'I follow "Nuevo"'
    step "I fill required data for assignment entitled \"TP#{n}\""
  end
  @assignment_date = Date.today + 2
  step 'I follow "Nuevo"'
  step "I fill data for non blocking assignment \"TP2\" due to \"#{@assignment_date}\" to be delivered as \"link\""
end

Given /^there is a blocking assignment "(.*?)" with due date "(.*?)" already created$/ do |assignment_name, date|
  assignment = Assignment.all.select{|assignment| assignment.name == assignment_name}.first
  assignment.is_blocking = true
  assignment.deadline = date
  assignment.save
end

Then /^I should get file of "(.*?)"$/ do |assignment_name|
  step "I should get file \"#{assignment_name.downcase}.zip\""
end

Given /^"(.*)" has solution submitted by student$/ do |assignment_name|
    step 'I am logged in as student'
    step 'I follow "Trabajos prácticos"'
    step "I click submit solution for \"#{assignment_name}\""
    step "I upload the solution\'s file for \"#{assignment_name}\""
    step 'I logged out'
end

Given /^"(.*)" has link solution submitted by student$/ do |assignment_name|
    step 'I am logged in as student'
    step 'I follow "Trabajos prácticos"'
    step "I click submit solution for \"#{assignment_name}\""
    step 'I fill in link to solution'
    step 'I click save button'
    step 'I logged out'
end

Then /^I should see "(.*)" correction's status by student$/ do |assignment_name| 
  query = ""                                      <<  \
    "//tr"                                        <<  \
    "/td[contains(., '#{@student.full_name}')]"   <<  \
    "/.."                                         <<  \
    "/td[contains(., '#{@student.tag}')]"         <<  \
    "/.."                                         <<  \
    "/td[contains(., 'Corrección pendiente')]"

  expect { find(:xpath, query) }.to_not raise_error(Capybara::ElementNotFound)
end

Then /^I should see that date is incorrect$/ do
  step 'I should see "La fecha de entrega debe ser posterior a hoy"'
end

Then /^I should see that it was successfully created$/ do
  step 'I should see "creado exitosamente"'
end

Then /^assignment created should have "(.*?)" set as solution type$/ do |type|
  expect(Assignment.last.solution_type).to eq solution_type(type)
end

And(/^I click delete button for "(.*?)"$/) do |tp_name|
  @tp_name = tp_name
  click_button "Borrar #{@tp_name}"
end

When(/^I confirm it$/) do
  within "#delete-#{@tp_name}-assignment-modal" do
    click_button "Yes"
  end
end

Then(/^assignment "(.*?)" is deleted$/) do |arg1|
  expect(page).to_not have_content("TP0")
end

def solution_type(type)
  case type
  when 'file'
    solution = Assignment.FILE
  when 'link'
    solution = Assignment.LINK
  when ''
    solution = Assignment.FILE
  end
  solution
end
