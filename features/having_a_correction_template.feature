Feature:  Having a correction template

  Background:
    Given the course with teacher and student enrolled
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Nuevo"
    And I fill information for "TP0" with template "Bien: ---- Mal: ----- Regular: -------"
    And I click "Guardar"
  
  @wip
  Scenario: Professor seeing correction template
    Given a student submit solution for "TP0" with link
    Given I am logged in as teacher
    And I follow "Trabajos prácticos"
    And I follow "Correcciones" for "TP0"
    And I follow "Ver soluciones"
    And I click "Corregir"
    Then I should see "Bien: ---- Mal: ----- Regular: -------" within field "Comentarios públicos"