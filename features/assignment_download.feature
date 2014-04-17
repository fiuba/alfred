Feature: Download assignment's file
  As a teacher or as a student
  I want to download assignment file

  Background:
    Given the course with teacher and student enrolled 
    And there is a bunch of assignment already created

  Scenario: As a teacher I download assignment file
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Lista"
    And   I click download assignment file button for "TP1"
    Then  I should get file of "TP1"


  Scenario: As a student I download assignment file
    Given I am logged in as student
    And   I follow "Trabajos prácticos"
    And   I click download assignment file button for "TP1"
    Then  I should get file of "TP1"

