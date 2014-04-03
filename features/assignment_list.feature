Feature: Assignment list
  As enrolled user
  I want to see the list of created assignments for the course where I'm enrolled

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created

  Scenario: As a student 
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    Then  I should see "TP0"
    And   I should see "TP1"
    And   I should see "TP2"

  Scenario: As a teacher 
    Given I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    Then  I should see "TP0"
    And   I should see "TP1"
    And   I should see "TP2"

