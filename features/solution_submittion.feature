Feature: Solution submission
  As a student 
  I want to submit a solution for an assignment

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And the student "Richard"
    
  Scenario: Main flow with commment
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I comment "This is my comment for this solution"
    And   I upload the solution's file for "TP1"
    Then  I should see "Solution creado exitosamente"
    Then  solution should have comment: "This is my comment for this solution"
  
  Scenario: Comment empty
    Given a student submit solution for "TP1" with comment ""
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see no comment
    
  Scenario: Commenting
    Given a student submit solution for "TP1" with comment "This is my comment for this solution"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment: "This is my comment for this solution"
  
  Scenario: Comment with special characters
    Given a student submit solution for "TP1" with comment "ÁÉÍÓÚáéíóúÑñäëïöü"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment: "ÁÉÍÓÚáéíóúÑñäëïöü"
  
  Scenario: Comment not dissapearing when save is invalid
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I comment "This is my comment for this solution"
    When  I click save button
    And   I see save is invalid because no file was saved
    Then  I should see comment: "This is my comment for this solution"
  
    Scenario: Solution type: file - solution success
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I see there is a field to attach a file
    And   I do not see there is a field to write a link 
    When  I upload the solution's file for "TP1"
    Then  I should see solution was successfully created

  Scenario: Solution type: file - solution fail
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I see there is a field to attach a file
    And   I do not see there is a field to write a link 
    When  I click save button
    Then  I see save is invalid because no file was saved
    
  Scenario: Solution type: link - solution success
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP2"
    And   I do not see there is a field to attach a file
    And   I see there is a field to write a link
    When  I fill in link to solution
    And   I click save button
    Then  I should see solution was successfully created
  
  Scenario: Solution type: link - solution fail
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP2"
    And   I do not see there is a field to attach a file
    And   I see there is a field to write a link
    When  I click save button
    Then  I see save is invalid because no link was provided
    
#  Scenario: Submitting when blocking deadline has passed
#    Given there is a blocking assignment "TP2" with due date "22/10/2013" already created
#    And I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP2"
#    And   I upload the solution's file for "TP2"
#    Then  I should see "Esta entrega ha caducado"
    
#  Scenario: Submitting when blocking deadline has not passed
#    Given there is a blocking assignment "TP2" with due date "01/01/3000" already created
#    And I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP2"
#    And   I upload the solution's file for "TP2"
#    Then  I should see "Solution creado exitosamente"
  
#  Scenario: Submitting when non blocking deadline has not passed
#    Given there is a non blocking assignment "TP2" with due date "01/01/3000" already created
#    And I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP2"
#    And   I upload the solution's file for "TP2"
#    Then  I should see "Solution creado exitosamente"
  
#  Scenario: Submitting when non blocking deadline has passed
#    Given there is a non blocking assignment "TP2" with due date "22/10/2013" already created
#    And I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP2"
#    And   I upload the solution's file for "TP2"
#    Then  I should see "Solution creado exitosamente"

