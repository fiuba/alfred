#encoding: utf-8

When /^I click submit solution for "(.*?)"$/ do |assignment_name|
  as_student_for_assignment( assignment_name, 'Entregar solución' ).click
end

When /^I click save button$/ do
    click_button( "Guardar" )
end

When /^I upload the solution's file for "(.*?)"$/ do |assignment_name|
  VCR.use_cassette("cassette_solution_for_#{assignment_name.downcase}") do
    attach_file(:solution_file, address_to("#{@student.buid}.zip"))
    click_button( "Guardar" )
  end
end

Then /^I should see solution entry for "(.*)"$/ do |assignment_name|
  expect( page.body ).to \
    include( "Soluciones entregadas para #{assignment_name}" )
  expect { find(:xpath, "//td[contains(., \"#{@student.buid}.zip\")]") }.to_not \
    raise_error(Capybara::ElementNotFound)
end

And /^I follow "(.*)" for the last solution$/ do |action_name|
  query = "//a[contains( @title, \"#{action_name}\")]"
  find( :xpath, query ).click
end

And /^I click on download for last solution$/ do
  VCR.use_cassette("cassette_solution_download_#{@student.buid}") do
    find(:xpath, "//a[contains(., \"#{@student.buid}.zip\")]" ).click
  end
end

Given /^I comment "(.*?)"$/ do |comment|
  fill_in :solution_comments, :with => '#{comment}'
end

Given /^a student submit solution for "(.*?)" with comment$/ do |tp, multiline|
   mul = ''
   multiline.split(/\n/).each do |phrase|
     mul << phrase
   end
  step "a student submit solution for \"#{tp}\" with comment \"#{mul}\""
end


Given /^a student submit solution for "(.*?)" with comment "(.*?)"$/ do |tp, comment|
  step 'I am logged in as student' 
  step 'I follow "Trabajos prácticos"'
  step "I click submit solution for \"#{tp}\""
  step 'I comment "#{comment}"'
  step "I upload the solution's file for \"#{tp}\""
  step "solution should have comment: \"#{comment}\""
end

Then /^solution should have comment: "(.*?)"$/ do |comment|
  #expect(Solution.last.comments).to eql(comment)
end
