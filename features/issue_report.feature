Feature: Issue Report Management

    Scenario: User superadmin can create an issue report
        Given I am create an User
        And I create a new Role superadmin for this user
        Then I create a new issue report logged in as this user
        And I should see the issue report in the list of issue reports