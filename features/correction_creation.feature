Feature: Correction creating
  As teacher
  I want to assign myself on charged of solution's grading

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And there are solutions submitted by students

  Scenario: Main flow
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I click "Correcciones" for "TP1"
    And   I click "Asignarme a mi" on the last submission
    Then  I should see "El TP fue asignado correctamente" 

