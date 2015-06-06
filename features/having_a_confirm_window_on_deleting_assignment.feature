Feature: Having a confirm window on deleting assignment

  Background:
    Given the course "2015-1"
    And the teacher "John"
    And I am logged in as teacher
    And there is a bunch of assignment already created
    When I follow "Lista"
    And I click delete button for "TP0"

  @wip
  Scenario: Confirming deletion
    When I confirm it
    Then assignment "TP0" is deleted

  @wip
  Scenario: Cancelling deletion
    When I cancel it
    Then assignment "TP0" is not deleted