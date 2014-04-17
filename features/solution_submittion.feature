Feature: Solution submition
  As a student 
  I want to submit a solution for a assignment

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And the student "Richard"

  Scenario: Main flow
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I upload the solution's file for "TP1"
    Then  I should see "Solution creado exitosamente" 

