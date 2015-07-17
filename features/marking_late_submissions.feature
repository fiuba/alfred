@wip
Feature: Marking late submissions

  Background:
    Given the course with teacher and student enrolled
    And I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Nuevo"
    And I fill data for blocking assignment "TP0" due to "22/06/2015" to be delivered as "link"
    And a student submit solution for "TP0" with link
    And A overdue solution for "TP0" submitted by a student

  Scenario: Submitting a solution overdue
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Correcciones" for "TP0"
    Then the solution for "TP0" is marked as "overdue"