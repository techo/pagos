Feature: Login as administrator

  Scenario: Login
    Given there is a registered administrator
    When I login as an administrator
    Then I should see the success message

  Scenario: Login failed
    When I try to login with invalid credentials
    Then I should see the failure message