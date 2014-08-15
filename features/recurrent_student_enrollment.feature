@wip
Feature: Course enrollment
  As a recurrent student 
  I want to enroll in the active course

  Background:
  	Given the course "2013-1"
  	And the student John Recurrent

  Scenario: Successful enrollment
  	Given I am logged in as student John Recurrent
    When I go to "the home page"
  	Then I should see "no esta anotado"
    When I click "aquí"
    Then I should see "Ha sido inscripto correctamente"