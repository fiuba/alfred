Feature: Profile update
  As a user
  I want to modify my profile information

  Background:
  	Given the course "2013-1"
  	And the teacher "John"

  Scenario: Main flow
  	Given I am logged in as teacher
    When I go to "the profile page"
  	When I edit my profile with name "Juan" and lastname "perez" and tag "jt"
    Then I should see "actualizado correctamente"

  Scenario: Password update
    Given I am logged in as teacher
    When I go to "the profile page"
    When I edit my profile with password "Password!" and password confirmation "Password!"
    Then I should see "actualizado correctamente"