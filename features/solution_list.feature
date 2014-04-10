Feature: List of solutions submitted
  As student
  I want to see solutions submitted by me

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And "TP1" has solution submitted by student

  Scenario: Main flow
    Given I am logged in as student
    And   I follow "Trabajos prácticos"
    And   I click "Ver todas las soluciones" for "TP1"
    Then  I should see solution entry for "TP1"

