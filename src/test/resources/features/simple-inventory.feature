Feature: Simple Inventory API Tests
  Basic API tests without complex configuration

  Background:
    Given url 'http://localhost:3100/api'

  @smoke
  Scenario: Get inventory items
    Given path 'inventory'
    When method GET
    Then status 200
    And match response != null
    And match response == '#[array]'

  @smoke  
  Scenario: Add inventory item
    Given path 'inventory', 'add'
    And def newItem = { id: 999, name: 'Test Item', price: 29.99, image: 'test.jpg' }
    And request newItem
    When method POST
    Then status 200
    And match response != null
