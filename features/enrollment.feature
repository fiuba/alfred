Feature: Student enrollement
  As a student 
  I want to enrole on Alfred

  Background:
    Given the course "2011-1"

  Scenario: Main flow
    Given I am on the home page
    And   I follow "crear cuenta"
    And   I enrole as student named "Tom"
    Then  I should see "Cuenta creada"
    And   I log in as "Tom"
    Then  I should see "Mis trabajos prácticos"


  Scenario: Re-Enrollment
    Given I am on the home page
    And   I follow "crear cuenta"
    And   I enrole as student named "Tom"
    Then  I should see "Cuenta creada" 
    Given the course "2014-1"
    And   I log in as "Tom"
    Then I should see "IMPORTANTE" 
