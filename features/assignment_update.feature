Feature: Assigment updating
  As a teacher 
  I want to update/edit/fix either name or deadline or script of ass assignments

  Background:
    Given the course "2013-1"
    And the teacher "John"
    And the assignment entitled "TP0"
    And the assignment entitled "TP1"
    And the assignment entitled "TP2"

  Scenario: Main flow
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Lista"
    And   I click edit button edit on "TP2"
    And   I update data intended to be updated for assignment "TP2"
    Then  I should see "fue actualizado correctamente"
    And   The assignment entitled "TP2" should be properly updated 

  Scenario: Changing date to today
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Lista"
    And   I click edit button edit on "TP2"
    And   I update data with new date "today" intended to be updated for assignment "TP2"
    Then  I should see that date is incorrect
    And   The assignment entitled "TP2" should not be updated

  Scenario: Changing date to a day before today
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Lista"
    And   I click edit button edit on "TP2"
    And   I update data with new date "11/04/2014" intended to be updated for assignment "TP2"
    Then  I should see that date is incorrect
    And   The assignment entitled "TP2" should not be updated
