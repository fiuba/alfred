Feature: Password recovery

  Background:
    Given the course with teacher and student enrolled
    Given I am on login
    And I follow "¿Olvidó su contraseña?"
    And I fill in "Email" with "Richard@someplace.com"
    And I should receive a reset password email after clicking "Restablecer"

  Scenario: Accessing with new password
    And I fill in "email" with "Richard@someplace.com"
    And I fill in password with the new one generated
    And I click "iniciar sesión"
    And I am on the home page
    Then I should see "¡Bienvenido!"