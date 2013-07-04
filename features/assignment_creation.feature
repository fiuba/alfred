Feature: Assigment creation
  As a teacher 
  I want to create assignments
  To evaluate my students

  Background:
  	Given the course "2013-1"
  	And the teacher "John"

  Scenario: Main flow
  	Given I am logged in as teacher
  	Then Log out menu option show be visible
  	

