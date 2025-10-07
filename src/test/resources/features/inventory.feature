Feature: Inventory API Tests
  Test suite for inventory management API endpoints
  Tests GET /api/inventory, GET /api/inventory/filter, and POST /api/inventory/add

  Background:
    # Common setup for all scenarios
    Given url baseUrl
    And def inventorySchema = read('classpath:schemas/inventory-schema.json')
    And def testData = read('classpath:test-data/inventory.json')

  @smoke
  Scenario: Get all inventory items
    # Test GET /api/inventory endpoint
    Given path 'inventory'
    When method GET
    Then status 200
    And match response != null
    And match response == '#[array]'
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And def itemCount = response.length
    And print 'Total inventory items:', itemCount

  @smoke
  Scenario: Get filtered inventory items
    # Test GET /api/inventory/filter?id=3 endpoint
    Given path 'inventory', 'filter'
    And param id = 3
    When method GET
    Then status 200
    And match response != null
    And match response == '#[array]'
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And def filteredCount = response.length
    And print 'Filtered inventory items:', filteredCount

  @smoke
  Scenario: Add new inventory item
    # Test POST /api/inventory/add endpoint
    Given path 'inventory', 'add'
    And def newItem = { id: 999, name: 'Test Item', price: 29.99, image: 'test-image.jpg' }
    And request newItem
    When method POST
    Then status 200
    And match response != null
    And match response contains { id: 999, name: 'Test Item', price: 29.99, image: 'test-image.jpg' }

  @regression
  Scenario: Validate inventory item schema
    # Test schema validation for inventory items
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And match response[*].id == '#number'
    And match response[*].name == '#string'
    And match response[*].price == '#number'
    And match response[*].image == '#string'

  @regression
  Scenario: Test inventory item count consistency
    # Test that item counts are consistent
    Given path 'inventory'
    When method GET
    Then status 200
    And def allItems = response
    And def allItemCount = allItems.length
    
    # Get filtered items
    Given path 'inventory', 'filter'
    And param id = 3
    When method GET
    Then status 200
    And def filteredItems = response
    And def filteredItemCount = filteredItems.length
    
    # Verify filtered count is less than or equal to total count
    And assert filteredItemCount <= allItemCount

  @regression
  Scenario: Test inventory item price validation
    # Test that all prices are positive numbers
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*].price == '#number'
    And def prices = response[*].price
    And assert prices[*] > 0

  @regression
  Scenario: Test inventory item name validation
    # Test that all names are non-empty strings
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*].name == '#string'
    And def names = response[*].name
    And assert names[*] != null
    And assert names[*] != ''

  @regression
  Scenario: Test inventory item image validation
    # Test that all images are non-empty strings
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*].image == '#string'
    And def images = response[*].image
    And assert images[*] != null
    And assert images[*] != ''

  @regression
  Scenario: Test inventory item ID validation
    # Test that all IDs are positive numbers
    Given path 'inventory'
    When method GET
    Then status 200
    And match response[*].id == '#number'
    And def ids = response[*].id
    And assert ids[*] > 0

  @regression
  Scenario: Test inventory response time
    # Test that API response time is acceptable
    Given path 'inventory'
    When method GET
    Then status 200
    And def responseTime = responseTime
    And assert responseTime < 5000

  @regression
  Scenario: Test inventory item uniqueness
    # Test that all item IDs are unique
    Given path 'inventory'
    When method GET
    Then status 200
    And def ids = response[*].id
    And def uniqueIds = karate.distinct(ids)
    And assert ids.length == uniqueIds.length

