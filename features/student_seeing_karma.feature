Feature: Giving karma to a student

  Background:
    Given I am logged in as teacher
    And I follow "Alumnos"
    And I follow "Ver estados de los TPs" within "Richard"
    And I click "asignar karma"

  Scenario: Student seeing his karma
    Given I am logged in as student
    And I follow "Trabajos Prácticos"
    Then there should be 1 karma points