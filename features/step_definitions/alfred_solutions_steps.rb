#encoding: utf-8

When /^I click submit solution for "(.*?)"$/ do |assignment_name|
  as_student_for_assignment( assignment_name, 'Entregar solución' ).click
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

And /^I click "(.*)" for last solution$/ do |action_name|
  query = "//a[contains( @title, \"#{action_name}\")]"
  find( :xpath, query ).click
end
