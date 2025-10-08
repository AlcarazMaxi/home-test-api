Feature: Inventory API Negative Tests
  Test suite for negative scenarios and error handling
  Tests invalid requests, missing fields, and error responses

  Background:
    # Common setup for negative tests
    Given url baseUrl
    And def errorMessage = 'Not all requirements are met'

  @regression
  Scenario: Test POST with missing required fields
    # Test POST /api/inventory/add with missing fields
    Given path 'inventory', 'add'
    And def incompleteItem = { id: 999, name: 'Test Item' }
    And request incompleteItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with wrong data types
    # Test POST /api/inventory/add with wrong data types
    Given path 'inventory', 'add'
    And def invalidItem = { id: 'invalid', name: 123, price: 'invalid', image: 456 }
    And request invalidItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with empty fields
    # Test POST /api/inventory/add with empty fields
    Given path 'inventory', 'add'
    And def emptyItem = { id: 999, name: '', price: 29.99, image: '' }
    And request emptyItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with negative price
    # Test POST /api/inventory/add with negative price
    Given path 'inventory', 'add'
    And def negativePriceItem = { id: 999, name: 'Test Item', price: -10.99, image: 'test-image.jpg' }
    And request negativePriceItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with zero price
    # Test POST /api/inventory/add with zero price
    Given path 'inventory', 'add'
    And def zeroPriceItem = { id: 999, name: 'Test Item', price: 0, image: 'test-image.jpg' }
    And request zeroPriceItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with duplicate ID
    # Test POST /api/inventory/add with duplicate ID
    Given path 'inventory', 'add'
    And def duplicateItem = { id: 1, name: 'Duplicate Item', price: 29.99, image: 'duplicate-image.jpg' }
    And request duplicateItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with very long name
    # Test POST /api/inventory/add with very long name
    Given path 'inventory', 'add'
    And def longNameItem = { id: 999, name: 'a'.repeat(1000), price: 29.99, image: 'test-image.jpg' }
    And request longNameItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with special characters in name
    # Test POST /api/inventory/add with special characters in name
    Given path 'inventory', 'add'
    And def specialCharItem = { id: 999, name: 'Test@#$%^&*()Item', price: 29.99, image: 'test-image.jpg' }
    And request specialCharItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with null values
    # Test POST /api/inventory/add with null values
    Given path 'inventory', 'add'
    And def nullItem = { id: null, name: null, price: null, image: null }
    And request nullItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with extra fields
    # Test POST /api/inventory/add with extra fields
    Given path 'inventory', 'add'
    And def extraFieldItem = { id: 999, name: 'Test Item', price: 29.99, image: 'test-image.jpg', extraField: 'extra' }
    And request extraFieldItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with missing id field
    # Test POST /api/inventory/add with missing id field
    Given path 'inventory', 'add'
    And def noIdItem = { name: 'Test Item', price: 29.99, image: 'test-image.jpg' }
    And request noIdItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with missing name field
    # Test POST /api/inventory/add with missing name field
    Given path 'inventory', 'add'
    And def noNameItem = { id: 999, price: 29.99, image: 'test-image.jpg' }
    And request noNameItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with missing price field
    # Test POST /api/inventory/add with missing price field
    Given path 'inventory', 'add'
    And def noPriceItem = { id: 999, name: 'Test Item', image: 'test-image.jpg' }
    And request noPriceItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with missing image field
    # Test POST /api/inventory/add with missing image field
    Given path 'inventory', 'add'
    And def noImageItem = { id: 999, name: 'Test Item', price: 29.99 }
    And request noImageItem
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with empty request body
    # Test POST /api/inventory/add with empty request body
    Given path 'inventory', 'add'
    And request {}
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }
    And match response.message == errorMessage

  @regression
  Scenario: Test POST with invalid JSON
    # Test POST /api/inventory/add with invalid JSON
    Given path 'inventory', 'add'
    And request 'invalid json'
    When method POST
    Then status 400
    And match response != null
    And match response contains { message: '#string' }

  @regression
  Scenario: Test GET with invalid filter parameter
    # Test GET /api/inventory/filter with invalid parameter
    Given path 'inventory', 'filter'
    And param id = 'invalid'
    When method GET
    Then status 400
    And match response != null
    And match response contains { message: '#string' }

  @regression
  Scenario: Test GET with negative filter parameter
    # Test GET /api/inventory/filter with negative parameter
    Given path 'inventory', 'filter'
    And param id = -1
    When method GET
    Then status 400
    And match response != null
    And match response contains { message: '#string' }

  @regression
  Scenario: Test GET with zero filter parameter
    # Test GET /api/inventory/filter with zero parameter
    Given path 'inventory', 'filter'
    And param id = 0
    When method GET
    Then status 400
    And match response != null
    And match response contains { message: '#string' }

