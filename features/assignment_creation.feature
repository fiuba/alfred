Feature: Assigment creation
  As a teacher 
  I want to create assignments
  To evaluate students which are enrolled in the course whose teacher I'm

  Background:
    Given the course "2013-1"
    And the teacher "John"

  Scenario: Main flow
    Given I am logged in as teacher
    And   I follow "Trabajos prácticos"
    And   I follow "Nuevo"
    And   I fill in "assignment_name" with "TP0" within ".form-horizontal"
    And   I fill in "assignment_test_script" with "#!/bin/bash\necho $?" within ".form-horizontal"
    And   I fill in "assignment_deadline" with "20/10/2013" within ".form-horizontal"
    And   I attach the file "tp0.zip" to "assignment_file" within ".form-horizontal"
    And   I press "Guardar y continuar" within ".form-horizontal" using "cassette_assignment_new"
    Then  I should see "Assignment creado exitosamente" 

