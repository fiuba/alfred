Feature: Correction creation
  As teacher
  I want to assign a teacher on charge of solution's grading

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And there are solutions submitted by students
    And the teacher "Carla"

  Scenario: Main flow
    Given   I am logged in as teacher 
    When   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignarme a mi" on the last submission
    Then  I should see "El TP fue asignado correctamente" 

  Scenario: Delegating to a teacher
    Given I am logged in as teacher 
    When  I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignar a otro" on the last submission
    And   I choose "Carla some_surname" as teacher for the correction
    And   I click "Guardar"
    Then  I should see "El TP fue asignado correctamente"
    And   I should see "Carla some_surname" as "Corrector" on the last submission

  Scenario: Canceling delegation
    Given I am logged in as teacher 
    When  I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignar a otro" on the last submission
    And   I choose "Carla some_surname" as teacher for the correction
    And   I click "Cancelar"
    Then  I should not see "El TP fue asignado correctamente"