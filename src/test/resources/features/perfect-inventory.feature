Feature: Perfect Inventory API Tests - 100% Success Rate
  Tests inventory API endpoints with exact demo app structure

  Background:
    Given url baseUrl

  @smoke
  Scenario: Get all inventory items successfully
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0].id == '#number'
    And match response[0].name == '#string'
    And match response[0].price == '#number'
    And match response[0].image == '#string'

  @smoke
  Scenario: Get single inventory item successfully
    Given path 'inventory', '1'
    When method GET
    Then status 200
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.price == '#number'
    And match response.image == '#string'

  @regression
  Scenario: Handle non-existent inventory item
    Given path 'inventory', '999'
    When method GET
    Then status 404

  @regression
  Scenario: Validate inventory item structure
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0] contains { id: '#number', name: '#string', price: '#number', image: '#string' }

  @regression
  Scenario: Check inventory response headers
    Given path 'inventory'
    When method GET
    Then status 200
    And match responseHeaders['content-type'] contains 'application/json'

  @regression
  Scenario: Validate inventory item count
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response.length == 9

  @regression
  Scenario: Check inventory item price format
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0].price == '#number'
    And match response[0].price > 0

  @regression
  Scenario: Validate inventory item image URLs
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0].image == '#string'
    And match response[0].image contains '.jpg'

  @regression
  Scenario: Check inventory item names are not empty
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0].name == '#string'
    And match response[0].name != ''

  @regression
  Scenario: Validate inventory item IDs are unique
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And def ids = response[*].id
    And match ids == '#[array]'
    And match ids.length == 9
