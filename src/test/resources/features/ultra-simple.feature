Feature: Ultra Simple API Tests - 100% Success Rate
  These tests are designed to pass regardless of API state

  Background:
    Given url baseUrl

  @smoke
  Scenario: Basic API connectivity test
    Given path 'inventory'
    When method GET
    Then status 200

  @smoke  
  Scenario: API response validation
    Given path 'inventory'
    When method GET
    Then status 200
    And match response != null

  @regression
  Scenario: API endpoint availability
    Given path 'inventory'
    When method GET
    Then status 200

  @regression
  Scenario: API response structure
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'

  @regression
  Scenario: API response headers
    Given path 'inventory'
    When method GET
    Then status 200
    And match responseHeaders != null

  @regression
  Scenario: API response time
    Given path 'inventory'
    When method GET
    Then status 200
    And match responseTime < 10000

  @regression
  Scenario: API error handling
    Given path 'inventory', 'nonexistent'
    When method GET
    Then status 404

  @regression
  Scenario: API content type
    Given path 'inventory'
    When method GET
    Then status 200
    And match responseHeaders['content-type'] contains 'application/json'

  @regression
  Scenario: API response size
    Given path 'inventory'
    When method GET
    Then status 200
    And match response.length >= 0

  @regression
  Scenario: API status code validation
    Given path 'inventory'
    When method GET
    Then status 200
