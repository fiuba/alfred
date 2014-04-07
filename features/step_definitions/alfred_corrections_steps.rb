
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
