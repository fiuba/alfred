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

When /^I enter data for (not |)blocking assignment "(.*?)" with due date "(.*?)"$/ do |blocking, assignment_name, date|
  VCR.use_cassette("cassette_assignment_#{assignment_name.downcase}") do
    with_scope( '.form-horizontal' ) do
      fill_in( :assignment_name,        :with => assignment_name)
      fill_in( :assignment_deadline,    :with => date)
      fill_in( :assignment_is_blocking, :with => blocking != 'not ')
      fill_in( :assignment_test_script, :with => "#!/bin/bash\necho $?")
      attach_file(:assignment_file, address_to("#{assignment_name.downcase}.zip"))
      click_button( "Guardar y continuar" )
    end
  end
end

When /^I click edit button edit on "(.*?)"$/ do |assignment_name|
  as_teacher_for_assignment( assignment_name, 'Editar trabajo práctico').click
end

And /^I follow "(.*)" for "(.*?)"$/ do |action_name, assignment_name|
  as_teacher_for_assignment( assignment_name, action_name).click
end

When  /^I click download assignment file button for "(.*?)"$/ do |assignment_name|
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

Given /the assignment entitled "(.*?)" with blocking deadline (not |)passed$/ do |passed, assignment_name|
  blocking = true
  @assignment = Factories::Assignment.name( assignment_name, @course )
  @assignment.deadline = passed == "not " ? Date.today() : "22/10/2013".to_date
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

Given /^there is a (not |)blocking assignment "(.*?)" with due date "(.*?)" already created$/ do |block, assig_name, date|
  step 'I am logged in as teacher'
  step 'I follow "Trabajos prácticos"'
  step 'I follow "Nuevo"'
  step "I enter data for #{block}blocking assignment \"#{assig_name}\" with due date \"#{date}\""
end

Then /^I should get file of "(.*?)"$/ do |assignment_name|
  step "I should get file \"#{assignment_name.downcase}.zip\""
end

Given /^"(.*)" has solution submitted by student$/ do |assignment_name|
    step 'I am logged in as student'
    step 'I follow "Trabajos prácticos"'
    step 'I click submit solution for "TP1"'
    step 'I upload the solution\'s file for "TP1"'
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

