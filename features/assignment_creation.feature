Feature: Assigment creation
  As a teacher 
  I want to create assignments
  To evaluate students which are enrolled in the course whose teacher I'm

  Background:
    Given the course "2013-1"
    And the teacher "John"

  Scenario: Main flow
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    And   I fill requeried data for assignment entitled "TP0"
    Then  I should see "Assignment creado exitosamente" 

