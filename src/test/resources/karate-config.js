/**
 * Karate configuration file
 * Contains global configuration and utility functions
 */

// Global configuration
function configure() {
  // Set base URL from environment variable or default
  var baseUrl = java.lang.System.getProperty('karate.env') === 'prod' 
    ? 'https://api.example.com' 
    : 'http://localhost:3100/api';
  
  // Configure Karate
  var config = {
    // Base URL for all API calls
    baseUrl: baseUrl,
    
    // Timeout settings
    connectTimeout: 10000,
    readTimeout: 30000,
    
    // Retry settings
    retryCount: 3,
    retryInterval: 1000,
    
    // Logging settings
    logLevel: 'INFO',
    
    // Test data settings
    testData: {
      validUser: {
        username: 'testuser',
        password: 'testpass'
      },
      invalidUser: {
        username: 'invaliduser',
        password: 'wrongpass'
      }
    }
  };
  
  return config;
}

/**
 * Utility function to generate random test data
 * @param {string} type - Type of data to generate
 * @returns {string} Generated data
 */
function generateTestData(type) {
  var timestamp = new Date().getTime();
  
  switch(type) {
    case 'id':
      return Math.floor(Math.random() * 1000) + timestamp;
    case 'name':
      return 'Test Item ' + timestamp;
    case 'price':
      return (Math.random() * 100 + 1).toFixed(2);
    case 'email':
      return 'test' + timestamp + '@example.com';
    default:
      return 'test' + timestamp;
  }
}

/**
 * Utility function to validate JSON schema
 * @param {object} data - Data to validate
 * @param {object} schema - Schema to validate against
 * @returns {boolean} Validation result
 */
function validateSchema(data, schema) {
  try {
    // Check if data has required fields
    for (var field in schema.required) {
      if (!data[field]) {
        return false;
      }
    }
    
    // Check field types
    for (var field in schema.properties) {
      if (data[field]) {
        var expectedType = schema.properties[field].type;
        var actualType = typeof data[field];
        
        if (expectedType === 'number' && actualType !== 'number') {
          return false;
        }
        if (expectedType === 'string' && actualType !== 'string') {
          return false;
        }
        if (expectedType === 'boolean' && actualType !== 'boolean') {
          return false;
        }
      }
    }
    
    return true;
  } catch (e) {
    return false;
  }
}

/**
 * Utility function to clean up test data
 * @param {string} endpoint - API endpoint to clean up
 * @param {string} method - HTTP method
 * @param {object} data - Data to send
 */
function cleanupTestData(endpoint, method, data) {
  try {
    // Perform cleanup request
    var response = karate.call('classpath:features/common/cleanup.feature', {
      endpoint: endpoint,
      method: method,
      data: data
    });
    
    karate.log('Cleanup completed for endpoint:', endpoint);
  } catch (e) {
    karate.log('Cleanup failed for endpoint:', endpoint, 'Error:', e.message);
  }
}

/**
 * Utility function to wait for condition
 * @param {function} condition - Condition to wait for
 * @param {number} timeout - Timeout in milliseconds
 * @param {number} interval - Check interval in milliseconds
 * @returns {boolean} Whether condition was met
 */
function waitForCondition(condition, timeout, interval) {
  var startTime = new Date().getTime();
  var endTime = startTime + timeout;
  
  while (new Date().getTime() < endTime) {
    try {
      if (condition()) {
        return true;
      }
    } catch (e) {
      // Continue waiting
    }
    
    java.lang.Thread.sleep(interval);
  }
  
  return false;
}

/**
 * Utility function to format error messages
 * @param {object} response - API response
 * @param {string} expectedMessage - Expected error message
 * @returns {string} Formatted error message
 */
function formatErrorMessage(response, expectedMessage) {
  var actualMessage = response.message || response.error || 'Unknown error';
  return 'Expected: ' + expectedMessage + ', Actual: ' + actualMessage;
}

/**
 * Utility function to extract data from response
 * @param {object} response - API response
 * @param {string} path - JSON path to extract
 * @returns {object} Extracted data
 */
function extractData(response, path) {
  try {
    return karate.jsonPath(response, path);
  } catch (e) {
    karate.log('Failed to extract data from path:', path);
    return null;
  }
}

/**
 * Utility function to compare arrays
 * @param {array} array1 - First array
 * @param {array} array2 - Second array
 * @returns {boolean} Whether arrays are equal
 */
function compareArrays(array1, array2) {
  if (array1.length !== array2.length) {
    return false;
  }
  
  for (var i = 0; i < array1.length; i++) {
    if (array1[i] !== array2[i]) {
      return false;
    }
  }
  
  return true;
}

/**
 * Utility function to generate authentication headers
 * @param {string} token - Authentication token
 * @returns {object} Headers object
 */
function generateAuthHeaders(token) {
  return {
    'Authorization': 'Bearer ' + token,
    'Content-Type': 'application/json'
  };
}

/**
 * Utility function to validate response time
 * @param {number} responseTime - Response time in milliseconds
 * @param {number} maxTime - Maximum allowed time
 * @returns {boolean} Whether response time is acceptable
 */
function validateResponseTime(responseTime, maxTime) {
  return responseTime <= maxTime;
}

/**
 * Utility function to log test execution
 * @param {string} testName - Name of the test
 * @param {string} status - Test status (PASS/FAIL)
 * @param {object} details - Additional details
 */
function logTestExecution(testName, status, details) {
  var timestamp = new Date().toISOString();
  var logMessage = '[' + timestamp + '] ' + testName + ' - ' + status;
  
  if (details) {
    logMessage += ' - ' + JSON.stringify(details);
  }
  
  karate.log(logMessage);
}

// Export configuration and utilities
module.exports = {
  configure: configure,
  generateTestData: generateTestData,
  validateSchema: validateSchema,
  cleanupTestData: cleanupTestData,
  waitForCondition: waitForCondition,
  formatErrorMessage: formatErrorMessage,
  extractData: extractData,
  compareArrays: compareArrays,
  generateAuthHeaders: generateAuthHeaders,
  validateResponseTime: validateResponseTime,
  logTestExecution: logTestExecution
};

