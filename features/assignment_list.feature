Feature: Solution submition
  As a student 
  I want to see the list of created assignments for the course where I'm enrolled

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And the student "Richard"

  Scenario: Main flow
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    Then  I should see "TP0"
    And   I should see "TP1"
    And   I should see "TP2"

