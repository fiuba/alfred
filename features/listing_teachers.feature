Feature: Listing teachers
  Background:
    Given the course with teacher and student enrolled

  Scenario: Students seeing teaching staff
    And I am logged in as student
    When I follow "Equipo docente"
    Then I should see "John@someplace.com" on "Email" for user "John some_surname"
    Then I should see an image for "John"

  Scenario: Teachers seeing teaching staff
    And I am logged in as teacher
    When I follow "Equipo docente"
    Then I should see "John@someplace.com" on "Email" for user "John some_surname"
    Then I should see an image for "John"