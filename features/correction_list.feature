Feature: Correction list
  As teacher
  I want to see my correction list

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And there are solutions submitted by students

  Scenario: Main flow
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignarme a mi" on the last submission
    And   I go to the homepage
    And   I follow "Mis correcciones" 
    Then  I should see correction entry for "TP1"

