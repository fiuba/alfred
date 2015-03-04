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
    And   I should not see last correction entry for "TP1" highlighted
   
  Scenario: Accessing solution file
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignarme a mi" on the last submission
    And   I go to the homepage
    When  I follow "Mis correcciones"
    Then  I should see correction entry for "TP1"
    And   I should not be able to go to solution link for "TP1"
    And   I should be able to download solution for "TP1"

  Scenario: Accessing solution link
    And   I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP2"
    And   I click "Asignarme a mi" on the last submission
    And   I go to the homepage
    When  I follow "Mis correcciones"
    Then  I should see correction entry for "TP2"
    And   I should not be able to download solution for "TP2"
    And   I should be able to go to solution link for "TP2"

  Scenario: Overdue solution submitted
    Given A overdue solution for "TP1" submitted by a student
    And   I am logged in as teacher
    When  I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I click "Asignarme a mi" on the last submission
    And   I go to the homepage
    And   I follow "Mis correcciones" 
    Then  I should see correction entry for "TP1"
    And   I should see last correction entry for "TP1" highlighted
