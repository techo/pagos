Feature: Assignments

  Background:
    Given I am logged in as an administrator
    And I have few volunteers

  @javascript
  Scenario: Associating a volunteer with a location
    Given I am on the assignments page
    And I should see the provinces displayed in a dropdown box
    When I select province from the dropdown
    Then I should see the list of locations under that province
    When I select a location
    Then I should see all the associated with that location
    When I select the checkbox of a volunteer
    Then the volunteer is automatically assigned to that location