Feature: Example Test for Google Search

  @google
  Scenario: URL Should Contain Search Criteria
    Given I am the Google Homepage
    When I perform a search for "cool things"
    Then I should see that the URL contains my search criterion

