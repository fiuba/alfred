@wip
Feature:  Having a correction template

  Background:
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Nuevo"
    And I fill information for "TP0" with template "Bien: ---- Mal: ----- Regular: -------"
    And I click "Guardar"

  Scenario: Professor seeing correction template
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Correcciones" for "TP0"
    And I follow "Ver soluciones"
    And I follow "Corregir"
    Then I should see "Bien: ---- Mal: ----- Regular: -------" within "Comentarios públicos"