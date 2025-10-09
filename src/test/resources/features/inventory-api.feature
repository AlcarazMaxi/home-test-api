Feature: Inventory API Tests
  Background:
    Given url 'http://localhost:3100/api'

  @smoke
  Scenario: Get all menu items
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response.length >= 9
    And match response[*] contains { id: '#string', name: '#string', price: '#string', image: '#string' }

  @regression
  Scenario: Filter by id
    Given path 'inventory', 'filter'
    And param id = 3
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[0].id == '3'
    And match response[0].name == 'Baked Rolls x 8'
    And match response[0].price == '#string'
    And match response[0].image == '#string'

  @regression
  Scenario: Add item for non existent id
    Given path 'inventory', 'add'
    And def newItem = { id: '10', name: 'Hawaiian', image: 'hawaiian.png', price: '$14' }
    And request newItem
    When method POST
    Then status 200

  @regression
  Scenario: Add item for existent id
    Given path 'inventory', 'add'
    And def newItem = { id: '10', name: 'Hawaiian', image: 'hawaiian.png', price: '$14' }
    And request newItem
    When method POST
    Then status 400

  @regression
  Scenario: Try to add item with missing information
    Given path 'inventory', 'add'
    And def incompleteItem = { name: 'Hawaiian', image: 'hawaiian.png', price: '$14' }
    And request incompleteItem
    When method POST
    Then status 400
    And match response contains { message: 'Not all requirements are met' }

  @regression
  Scenario: Validate recent added item is present in the inventory
    Given path 'inventory'
    When method GET
    Then status 200
    And match response == '#[array]'
    And match response[*] contains { id: '10', name: 'Hawaiian', image: 'hawaiian.png', price: '$14' }
