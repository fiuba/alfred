@wip
Feature: Password recovery

  Background:
    Given I am on “login”
    And I follow "Olvidó su contraseña?"
    And I fill in "Email" with "Richard@someplace.com"
    And I click "Restablecer"
    And I received a reset password email

  Scenario: Accessing with new password
    And I fill in "Email" with "Richard@someplace.com"
    And I fill in password with the new one generated
    And I follow "Iniciar sesión"
    Then I should see "¡Bienvenido!"