Feature: List of solutions submitted
  As student
  I want to see solutions submitted by me and correction for this solution, as well

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And "TP1" has solution submitted by student
    And a teacher assigned himself as on-charge of correction

  Scenario: Seeing my solutions
    Given I am logged in as student
    And   I follow "Trabajos prácticos"
    And   I follow "Ver todas las soluciones" for "TP1"
    Then  I should see solution entry for "TP1"

  Scenario: Checking out correction for my solution
    Given I am logged in as student
    And   I follow "Trabajos prácticos"
    And   I follow "Ver todas las soluciones" for "TP1"
    And   I follow "Ver corrección" for the last solution
    Then  I should see "Corrección para TP1"

