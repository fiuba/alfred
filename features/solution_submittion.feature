Feature: Solution submition
  As a student 
  I want to submit a solution for a assignment

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created
    And the student "Richard"
    
  Scenario: Main flow with commment
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I comment "This is my comment for this solution"
    And   I upload the solution's file for "TP1"
    Then  I should see "Solution creado exitosamente"
    Then  solution should have comment: "This is my comment for this solution"
    
  Scenario: Comment empty
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I upload the solution's file for "TP1"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see no comment
    
  Scenario: Commenting
    Given a student submit solution for "TP1" with comment "This is my comment for this solution"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment: "This is my comment for this solution"
  
  Scenario: Comment with special characters
    Given a student submit solution for "TP1" with comment "ÁÉÍÓÚáéíóúÑñäëïöü|!"#$%&/()=<>_Ñ[]¡?,.-ñ{}¿'^·~¬°@*+\"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment: "ÁÉÍÓÚáéíóúÑñäëïöü|!"#$%&/()=<>_Ñ[]¡?,.-ñ{}¿'^·~¬°@*+\"
  
  Scenario: Comment not dissapearing when save is invalid
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I comment "This is my comment for this solution"
    When  I click save button
    Then  I should see comment: "This is my comment for this solution"
  
  Scenario: Comment long
    Given a student submit solution for "TP1" with comment 
        """
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times.
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times.
        """
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment:
        """
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times.
        This is a very large comment that I will write many times. 
        This is a very large comment that I will write many times.
        """
