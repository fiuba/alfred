Feature: Assignments's solution list
  As teacher
  I want to see solutions submitted by students

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created

  Scenario: Main flow
    Given "TP1" has solution submitted by student
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    Then  I should see "TP1" correction's status by student

  Scenario: Seeing solution files for assignment
    Given "TP1" has solution submitted by student
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I follow "Ver soluciones"
    Then  I should see solution files attached for assignment
    
  Scenario: Seeing solution links for assignment
    Given "TP2" has solution submitted by student
    And   I am logged in as teacher 
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP2"
    And   I follow "Ver soluciones"
    Then  I should see solution links provided for assignment

