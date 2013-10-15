Feature: Student enrollement
  As a student 
  I want to enrole on Alfred

  Background:
    Given the course "2013-1"

  Scenario: Main flow
    Given I am on the home page
    And   I follow "crear cuenta"
    And   I enrole as student named "Tom"
    Then  I should see "Cuenta creada"
    And   I log in as "Tom"


