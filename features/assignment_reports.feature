@wip
Feature: Assignment Reports
  Background:
    Given the course with teacher and student enrolled
    Given I am logged in as teacher

  Scenario:  Seeing no reports message
    And I follow "Trabajos prácticos"
    And I follow "Reportes"
    Then I should see "No hay trabajos prácticos creados, por lo tanto no se pueden crear reportes"

  Scenario: Seeing assignment reports table
    Given there is a bunch of assignment already created
    And there are solutions submitted by students
    And I follow "Trabajos prácticos"
    And I follow "Reportes"
    Then I should see "TP1"
    Then I should see "1" on "Entregados" for "TP1"
    Then I should see "0" on "Aprobados" for "TP1"
    Then I should see "0" on "Desaprobados" for "TP1"
    Then I should see "0" on "Promedio" for "TP1"