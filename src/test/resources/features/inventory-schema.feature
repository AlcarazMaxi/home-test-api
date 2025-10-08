Feature: Inventory Schema Validation Tests
  Test suite for JSON schema validation of inventory API responses
  Validates data structure, types, and constraints

  Background:
    # Common setup for schema validation
    Given url baseUrl
    And def inventorySchema = read('classpath:schemas/inventory-schema.json')

  @smoke
  Scenario: Validate inventory item schema structure
    # Test that inventory items match the expected schema
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And match response[*].id == '#number'
    And match response[*].name == '#string'
    And match response[*].price == '#number'
    And match response[*].image == '#string'

  @regression
  Scenario: Validate required fields are present
    # Test that all required fields are present in inventory items
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    And match items[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }

  @regression
  Scenario: Validate field types are correct
    # Test that field types match the schema
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Validate each item has correct field types
    And def firstItem = items[0]
    And assert firstItem.id == '#number'
    And assert firstItem.name == '#string'
    And assert firstItem.price == '#number'
    And assert firstItem.image == '#string'

  @regression
  Scenario: Validate no additional fields are present
    # Test that no unexpected fields are present
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Check that only expected fields are present
    And def firstItem = items[0]
    And def expectedFields = ['id', 'name', 'price', 'image']
    And def actualFields = firstItem.keySet()
    And assert actualFields.length == expectedFields.length

  @regression
  Scenario: Validate ID field constraints
    # Test that ID field meets schema constraints
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Validate ID constraints
    And def ids = items[*].id
    And assert ids[*] > 0
    And assert ids[*] < 1000000

  @regression
  Scenario: Validate name field constraints
    # Test that name field meets schema constraints
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Validate name constraints
    And def names = items[*].name
    And assert names[*] != null
    And assert names[*] != ''
    And assert names[*].length > 0
    And assert names[*].length <= 255

  @regression
  Scenario: Validate price field constraints
    # Test that price field meets schema constraints
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Validate price constraints
    And def prices = items[*].price
    And assert prices[*] > 0
    And assert prices[*] < 1000000

  @regression
  Scenario: Validate image field constraints
    # Test that image field meets schema constraints
    Given path 'inventory'
    When method GET
    Then status 200
    And def items = response
    And assert items.length > 0
    
    # Validate image constraints
    And def images = items[*].image
    And assert images[*] != null
    And assert images[*] != ''
    And assert images[*].length > 0
    And assert images[*].length <= 500

  @regression
  Scenario: Validate filtered inventory schema
    # Test that filtered inventory items match schema
    Given path 'inventory', 'filter'
    And param id = 3
    When method GET
    Then status 200
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And match response[*].id == '#number'
    And match response[*].name == '#string'
    And match response[*].price == '#number'
    And match response[*].image == '#string'

  @regression
  Scenario: Validate POST response schema
    # Test that POST response matches schema
    Given path 'inventory', 'add'
    And def newItem = { id: 999, name: 'Test Item', price: 29.99, image: 'test-image.jpg' }
    And request newItem
    When method POST
    Then status 200
    And match response contains { id: 999, name: 'Test Item', price: 29.99, image: 'test-image.jpg' }
    And match response.id == '#number'
    And match response.name == '#string'
    And match response.price == '#number'
    And match response.image == '#string'

  @regression
  Scenario: Validate schema consistency across endpoints
    # Test that all endpoints return consistent schema
    Given path 'inventory'
    When method GET
    Then status 200
    And def allItems = response
    
    # Get filtered items
    Given path 'inventory', 'filter'
    And param id = 3
    When method GET
    Then status 200
    And def filteredItems = response
    
    # Validate schema consistency
    And assert allItems[0].keySet() == filteredItems[0].keySet()
    And match allItems[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And match filteredItems[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
