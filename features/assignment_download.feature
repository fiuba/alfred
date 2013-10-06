Feature: Download assignment as a teacher
  As a teacher 
  I want to download assignment file

  Background:
    Given the course "2013-1"
    And the teacher "John"
    And there is a bunch of assignment already created

  Scenario: Main flow
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Lista"
    And   I click download assignment file button for "TP1"
    Then  I should get the file


