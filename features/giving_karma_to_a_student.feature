Feature: Giving karma to a student

  Background:
    Given the course with teacher and student enrolled
    Given I am logged in as teacher
    And I follow "Alumnos"
    And I follow "Ver estado de los TP" within "Richard"
    And I click "asignar karma"

  @wip
  Scenario: Student seeing his karma
    Given I am logged in as student
    And I follow "Trabajos prácticos"
    Then there should be 1 karma points