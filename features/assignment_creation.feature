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
    And   I fill required data for assignment entitled "TP0"
    Then  I should see "creado exitosamente" 

  Scenario: Choosing old date as due date
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    And   I fill required data for non blocking assignment "TP0" due to "10/09/2014"
    Then  I should see that date is incorrect
     
  Scenario: Choosing today as due date
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    And   I fill required data for non blocking assignment "TP0" due to "today"
    Then  I should see that date is incorrect
    
  Scenario: Choosing to have a file attached to solutions of assignment
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    When  I fill required data for assignment "TP0" to be delivered as "file"
    Then  I should see that it was successfully created
    And   assignment created should have "file" set as solution type
  
  Scenario: Choosing to have a link attached to solutions of assignment
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    When  I fill required data for assignment "TP0" to be delivered as "link"
    Then  I should see that it was successfully created
    And   assignment created should have "link" set as solution type
  
