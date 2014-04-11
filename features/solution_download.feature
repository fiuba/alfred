Feature: Solution downloads
  As enrolled user 
  I want to download solutions submitted by students

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And "TP1" has solution submitted by student
    And a teacher assigned himself as on-charge of correction

  Scenario: As student I want to download solution already submitted
    Given I am logged in as student
    And   I follow "Trabajos prácticos"
    And   I follow "Ver todas las soluciones" for "TP1"
    And   I click on download for last solution
    Then  I should get file "77666.zip"

  Scenario: As teacher I want to download solution submitted by student 
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Correcciones" for "TP1"
    And   I follow "Ver soluciones"
    And   I click on download for last solution
    Then  I should get file "77666.zip"


