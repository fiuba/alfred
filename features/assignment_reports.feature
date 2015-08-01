Feature: Assignment Reports
  Background:
    Given the course with teacher and student enrolled
    Given I am logged in as teacher

  Scenario:  Seeing no reports message
    And I follow "Trabajos prácticos"
    And I follow "Estadísticas"
    Then I should see "No hay trabajos prácticos creados, por lo tanto no se pueden crear reportes"

  Scenario: Seeing assignment reports table
    Given there is a bunch of assignment already created
    And there are solutions submitted by students
    And I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Estadísticas"
    Then I should see "TP1"
    Then I should see "1" on "Entregados" for "TP1"
    Then I should see "0" on "Aprobados" for "TP1"
    Then I should see "0" on "Desaprobados" for "TP1"
    Then I should see "--" on "Promedio-aprobados" for "TP1"
    Then I should see "--" on "Promedio-general" for "TP1"

  Scenario: Seeing assignment reports table with approved solutions
    Given there is a bunch of assignment already created
    And there are solutions submitted by students and corrected by me with grade "8"
    And I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Estadísticas"
    Then I should see "TP1"
    Then I should see "1" on "Entregados" for "TP1"
    Then I should see "1" on "Aprobados" for "TP1"
    Then I should see "0" on "Desaprobados" for "TP1"
    Then I should see "8" on "Promedio-aprobados" for "TP1"
    Then I should see "8" on "Promedio-general" for "TP1"

  Scenario: Seeing assignment reports table with not approved solutions
    Given there is a bunch of assignment already created
    And there are solutions submitted by students and corrected by me with grade "2"
    And I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Estadísticas"
    Then I should see "TP1"
    Then I should see "1" on "Entregados" for "TP1"
    Then I should see "0" on "Aprobados" for "TP1"
    Then I should see "1" on "Desaprobados" for "TP1"
    Then I should see "--" on "Promedio-aprobados" for "TP1"
    Then I should see "2" on "Promedio-general" for "TP1"

  Scenario: Seeing assignment reports table without solutions
    Given there is a bunch of assignment already created
    And I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Estadísticas"
    Then I should see "TP1"
    Then I should see "0" on "Entregados" for "TP1"
    Then I should see "0" on "Aprobados" for "TP1"
    Then I should see "0" on "Desaprobados" for "TP1"
    Then I should see "--" on "Promedio-aprobados" for "TP1"
    Then I should see "--" on "Promedio-general" for "TP1"