@wip
Feature: Students having a profile picture

  Background:
    Given the course with teacher and student enrolled
    And there is a bunch of assignment already created
    And "TP1" has solution submitted by student
    And a teacher assigned himself as on-charge of correction

  Scenario: Teacher seeing student profile picture
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Ver estado de los tps" within "Richard"
    Then I should see an image for "Richard"

  Scenario: Student seeing teacher profile picture
    Given I am logged in as student
    And I follow "Trabajos prácticos"
    And I follow "Ver todas las soluciones" within "TP1"
    And I click on "Ver corrección" for solution 1
    Then I should see an image for "John"