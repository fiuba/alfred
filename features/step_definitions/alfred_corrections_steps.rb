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
  step 'I click "Correcciones" for "TP1"'
  step 'I click "Asignarme a mi" on the last submission'
  step 'I logged out'
end

And /^I click "Asignarme a mi" on the last submission$/ do
  find( :xpath, "//button[last()]").click
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
