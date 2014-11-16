Feature: Solution submission
  As a student 
  I want to submit a solution for an assignment

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
  
#  Scenario: Submitting when blocking deadline has passed
#    Given there is a blocking assignment "TP0" with due date "22/10/2013" already created
#    Given I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP0"
#    And   I comment "This is my comment for this solution"
#    And   I upload the solution's file for "TP0"
#    Then  I should see "Esta entrega ha caducado"
    
#  Scenario: Submitting when blocking deadline has not passed
#    Given there is a blocking assignment "TP1" with due date today already created
#    Given I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP1"
#    And   I comment "This is my comment for this solution"
#    And   I upload the solution's file for "TP1"
#    Then  I should see "Solution creado exitosamente"
#  
#  Scenario: Submitting when not blocking deadline has not passed
#    Given there is a not blocking assignment "TP1" with due date today already created
#    Given I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP1"
#    And   I comment "This is my comment for this solution"
#    And   I upload the solution's file for "TP1"
#    Then  I should see "Solution creado exitosamente"
#  
#  Scenario: Submitting when not blocking deadline has passed
#    Given there is a not blocking assignment "TP0" with due date "22/10/2013" already created
#    Given I am logged in as student 
#    And   I follow "Trabajos prácticos"
#    And   I click submit solution for "TP0"
#    And   I comment "This is my comment for this solution"
#    And   I upload the solution's file for "TP0"
#    Then  I should see "Solution creado exitosamente"

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
    Given a student submit solution for "TP1" with comment "ÁÉÍÓÚáéíóúÑñäëïöü|!"$%&/()=<>_Ñ[]¡?,.-ñ{}¿'^·~¬°@*+\#"
    And   a teacher assigned himself as on-charge of correction
    When  as a teacher I go to correct last correction
    Then  I should see comment: "ÁÉÍÓÚáéíóúÑñäëïöü|!"$%&/()=<>_Ñ[]¡?,.-ñ{}¿'^·~¬°@*+\#"
  
  Scenario: Comment not dissapearing when save is invalid
    Given I am logged in as student 
    And   I follow "Trabajos prácticos"
    And   I click submit solution for "TP1"
    And   I comment "This is my comment for this solution"
    When  I click save button
    And   I see save is invalid because no file was saved
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

