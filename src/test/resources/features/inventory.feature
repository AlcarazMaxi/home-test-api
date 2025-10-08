Feature: Enhanced Inventory API Tests
  Comprehensive test suite for inventory management API endpoints
  Tests GET /api/inventory, GET /api/inventory/filter, and POST /api/inventory/add
  Includes schema validation, performance testing, and test isolation

  Background:
    # Common setup for all scenarios
    Given url baseUrl
    And def inventorySchema = read('classpath:schemas/inventory-schema.json')
    And def testData = read('classpath:test-data/inventory.json')
    # Generate unique session ID for test isolation
    And def sessionId = karate.call('classpath:karate-config.js').generateSessionId()
    And print 'Test session ID:', sessionId

  @smoke
  Scenario: Get all inventory items with comprehensive validation
    # Test GET /api/inventory endpoint with enhanced validation
    Given path 'inventory'
    When method GET
    Then status 200
    And match response != null
    And match response == '#[array]'
    And match response[*] contains { id: '#number', name: '#string', price: '#number', image: '#string' }
    And def itemCount = response.length
    And print 'Total inventory items:', itemCount
    # Validate minimum item count requirement
    And assert itemCount >= 9
    # Validate all required fields are present and correct types
    And match response[*].id == '#number'
    And match response[*].name == '#string'
    And match response[*].price == '#number'
    And match response[*].image == '#string'
    # Validate all IDs are positive
    And def ids = response[*].id
    And assert ids[*] > 0
    # Validate all prices are positive
    And def prices = response[*].price
    And assert prices[*] > 0
    # Validate all names are non-empty
    And def names = response[*].name
    And assert names[*] != null
    And assert names[*] != ''
    # Validate all images are non-empty
    And def images = response[*].image
    And assert images[*] != null
    And assert images[*] != ''

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
  Scenario: Add new inventory item with unique ID
    # Test POST /api/inventory/add endpoint with unique test data
    Given path 'inventory', 'add'
    # Generate unique test item to avoid conflicts
    And def uniqueId = karate.call('classpath:karate-config.js').generateUniqueId('item')
    And def newItem = { 
      id: uniqueId, 
      name: 'Test Item ' + sessionId, 
      price: 29.99, 
      image: 'test-image-' + sessionId + '.jpg',
      sessionId: sessionId
    }
    And request newItem
    When method POST
    Then status 200
    And match response != null
    And match response contains { id: '#string', name: '#string', price: '#number', image: '#string' }
    And match response.id == uniqueId
    And match response.name == 'Test Item ' + sessionId
    And match response.price == 29.99
    And match response.image == 'test-image-' + sessionId + '.jpg'

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

  @performance
  Scenario: Test inventory response time with performance thresholds
    # Test that API response time meets performance requirements
    Given path 'inventory'
    When method GET
    Then status 200
    And def responseTime = responseTime
    And print 'Response time:', responseTime, 'ms'
    # Validate response time is within acceptable limits
    And assert responseTime < 2000
    # Additional performance validation
    And def itemCount = response.length
    And def timePerItem = responseTime / itemCount
    And print 'Time per item:', timePerItem, 'ms'
    And assert timePerItem < 100

  @regression
  Scenario: Test inventory item uniqueness
    # Test that all item IDs are unique
    Given path 'inventory'
    When method GET
    Then status 200
    And def ids = response[*].id
    And def uniqueIds = karate.distinct(ids)
    And assert ids.length == uniqueIds.length

  @regression
  Scenario: Test inventory data consistency and integrity
    # Comprehensive test for data consistency across multiple calls
    Given path 'inventory'
    When method GET
    Then status 200
    And def firstCallData = response
    And def firstCallCount = firstCallData.length
    
    # Second call to verify consistency
    Given path 'inventory'
    When method GET
    Then status 200
    And def secondCallData = response
    And def secondCallCount = secondCallData.length
    
    # Verify data consistency
    And assert firstCallCount == secondCallCount
    And def firstIds = firstCallData[*].id
    And def secondIds = secondCallData[*].id
    And assert firstIds == secondIds

  @cleanup
  Scenario: Test inventory cleanup by session ID
    # Test cleanup functionality for test data isolation
    Given path 'inventory'
    When method GET
    Then status 200
    And def allItems = response
    And def sessionItems = allItems[*] contains { sessionId: sessionId }
    And print 'Items with session ID:', sessionItems.length
    # Note: Actual cleanup would be implemented in a separate cleanup feature
    And print 'Cleanup session ID for manual verification:', sessionId
