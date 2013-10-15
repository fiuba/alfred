Feature: Student enrollement
  As a student 
  I want to enrole on Alfred

  Scenario: Main flow
    Given I am on the home page
    And   I follow "crear cuenta"
    And   I enrole as student named "Tom"
    Then  I am logged as "Tom"


