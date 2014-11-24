#encoding: utf-8


Given /^there are solutions submitted by students$/ do
  step '"TP1" has solution submitted by student'
end

Then /^I should see correction entry for "(.*)"$/ do |assignment_name|
  query = ""                                      <<  \
    "//tr"                                        <<  \
    "/td[contains(., '#{assignment_name}')]"   <<  \
    "/.."                                         <<  \
    "/td[contains(., '#{@student.buid}')]"   <<  \
    "/.."                                         <<  \
    "/td[contains(., '#{@student.full_name}')]"   <<  \
    "/.."                                         <<  \
    "/td[contains(., 'En progreso')]"

  expect { find(:xpath, query) }.to_not raise_error(Capybara::ElementNotFound)
end

Given /^a teacher assigned himself as on-charge of correction$/ do
  step 'I am logged in as teacher'
  step 'I follow "Trabajos prácticos"'
  step 'I follow "Correcciones" for "TP1"'
  step 'I click "Asignarme a mi" on the last submission'
  step 'I logged out'
end

And /^I click "Asignarme a mi" on the last submission$/ do
  all(:xpath, "//button[@class='assign-to-me']").last.click
end

And /^I click "Asignar a otro" on the last submission$/ do
  all(:xpath, "//a[@id='solution_teacher_assign_button']").last.click
end

And /^I click "(.*)" on last correction$/ do |action_name| 
  as_teacher_for_assignment( 'TP1', action_name ).click
end

And /^I fill in correction's information$/ do
  fill_in :correction_public_comments, :with => 'Public comment'
  fill_in :correction_private_comments, :with => 'Private comment'
  fill_in :correction_grade, :with => '8.0'
  click_button 'Guardar y notificar'
end

And /^Correction's data successfuly updated$/ do
  correction = Correction.last
  expect( correction.public_comments).to eql('Public comment')
  expect( correction.private_comments).to eql('Private comment')
  expect( correction.grade).to eql(8.0)
  expect( correction.teacher).to eql(@teacher)
end

And /^Mail has been sent to student$/ do
  mail = MailerHelper.last_email
  expect( mail.to ).to include( @student.email )
  expect( mail.from ).to include( @teacher.email )
  expect( mail.body ).to include(
    "* Trabajo Practico: TP1", 
    "* Corrector: #{@teacher.name}, #{@teacher.email}",
    "* Calificacion: #{Correction.last.grade}",
    "* Comentarios: #{Correction.last.public_comments}" 
  )
end

Then /^I should see comment:$/ do |multiline|
  com = ''
  multiline.split(/\n/).each do |phrase|
    com << phrase
  end
  step "I should see comment: \"#{com}\""
end

Then /^I should see no comment$/ do
  step 'I should see comment: ""'
end

When /^as a teacher I go to correct last correction$/ do
  step 'I am logged in as teacher'
  step 'I go to the homepage'
  step 'I follow "Mis correcciones"' 
  step 'I click "Corregir" on last correction'
end

Then /^I should see comment: "(.*?)"$/ do |comment|
  step "I should see \"#{comment}\""
end

Given(/^I choose "(.*?)" as teacher$/) do |arg1|
  pending # express the regexp above with the code you wish you had
end

Then(/^I should see "(.*?)" as "(.*?)" on the last submission$/) do |arg1, arg2|
  pending # express the regexp above with the code you wish you had
end
