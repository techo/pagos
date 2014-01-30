Feature: Profiles

  Background:
    Given I am logged in as an administrator
    And I have few volunteers

  Scenario: Change role of a user
    When I change role of volunteer to administrator
    Then I should see his role is changed in database as well