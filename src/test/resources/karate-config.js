/**
 * Enhanced Karate configuration file
 * Contains global configuration, timeouts, retries, and utility functions
 */

// Global configuration with environment-specific settings
function configure() {
  // Get environment from system property or default to 'dev'
  var env = java.lang.System.getProperty('karate.env') || 'dev';
  
  // Set base URL based on environment
  var baseUrl;
  switch(env) {
    case 'prod':
      baseUrl = 'https://api.example.com';
      break;
    case 'staging':
      baseUrl = 'https://staging-api.example.com';
      break;
    case 'ci':
      baseUrl = 'http://demo-app:3100/api';
      break;
    case 'mock':
      baseUrl = 'http://localhost:3000';
      break;
    default:
      baseUrl = 'http://localhost:3100/api';
  }
  
  // Enhanced configuration with comprehensive settings
  var config = {
    // Base URL for all API calls
    baseUrl: baseUrl,
    
    // Environment-specific settings
    environment: env,
    
    // Enhanced timeout settings
    connectTimeout: parseInt(java.lang.System.getProperty('karate.connectTimeout', '10000')),
    readTimeout: parseInt(java.lang.System.getProperty('karate.readTimeout', '30000')),
    writeTimeout: parseInt(java.lang.System.getProperty('karate.writeTimeout', '30000')),
    
    // Retry configuration with exponential backoff
    retryCount: parseInt(java.lang.System.getProperty('karate.retryCount', '3')),
    retryInterval: parseInt(java.lang.System.getProperty('karate.retryInterval', '1000')),
    retryMultiplier: parseFloat(java.lang.System.getProperty('karate.retryMultiplier', '2.0')),
    maxRetryInterval: parseInt(java.lang.System.getProperty('karate.maxRetryInterval', '10000')),
    
    // Logging settings
    logLevel: java.lang.System.getProperty('karate.logLevel', 'INFO'),
    logPrettyRequest: java.lang.System.getProperty('karate.logPrettyRequest', 'true') === 'true',
    logPrettyResponse: java.lang.System.getProperty('karate.logPrettyResponse', 'true') === 'true',
    
    // Performance settings
    performance: {
      enableMetrics: java.lang.System.getProperty('karate.enableMetrics', 'true') === 'true',
      responseTimeThreshold: parseInt(java.lang.System.getProperty('karate.responseTimeThreshold', '2000')),
      p95Threshold: parseInt(java.lang.System.getProperty('karate.p95Threshold', '3000'))
    },
    
    // Test data settings with unique identifiers
    testData: {
      sessionId: generateSessionId(),
      validUser: {
        username: 'testuser',
        password: 'testpass'
      },
      invalidUser: {
        username: 'invaliduser',
        password: 'wrongpass'
      },
      testItem: {
        id: generateUniqueId('item'),
        name: 'Test Item ' + new Date().getTime(),
        price: 29.99,
        image: 'test-image.jpg'
      }
    },
    
    // Security settings
    security: {
      enableSecurityChecks: java.lang.System.getProperty('karate.enableSecurityChecks', 'false') === 'true',
      validateSSL: java.lang.System.getProperty('karate.validateSSL', 'true') === 'true'
    },
    
    // Reporting settings
    reporting: {
      generateReports: java.lang.System.getProperty('karate.generateReports', 'true') === 'true',
      reportDir: java.lang.System.getProperty('karate.reportDir', 'target/karate-reports'),
      includeRequestResponse: java.lang.System.getProperty('karate.includeRequestResponse', 'true') === 'true'
    }
  };
  
  return config;
}

/**
 * Generate unique session ID for test isolation
 * @returns {string} Unique session ID
 */
function generateSessionId() {
  return 'session_' + new Date().getTime() + '_' + Math.random().toString(36).substr(2, 9);
}

/**
 * Generate unique identifier with prefix
 * @param {string} prefix - Prefix for the identifier
 * @returns {string} Unique identifier
 */
function generateUniqueId(prefix) {
  return prefix + '_' + new Date().getTime() + '_' + Math.random().toString(36).substr(2, 6);
}

/**
 * Enhanced utility function to generate random test data
 * @param {string} type - Type of data to generate
 * @returns {string} Generated data
 */
function generateTestData(type) {
  var timestamp = new Date().getTime();
  var sessionId = generateSessionId();
  
  switch(type) {
    case 'id':
      return generateUniqueId('item');
    case 'name':
      return 'Test Item ' + timestamp;
    case 'price':
      return (Math.random() * 100 + 1).toFixed(2);
    case 'email':
      return 'test_' + sessionId + '@example.com';
    case 'username':
      return 'user_' + sessionId;
    default:
      return 'test_' + sessionId;
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
 * Enhanced utility function to wait for condition with exponential backoff
 * @param {function} condition - Condition to wait for
 * @param {number} timeout - Timeout in milliseconds
 * @param {number} interval - Initial check interval in milliseconds
 * @param {number} multiplier - Backoff multiplier (default: 1.5)
 * @returns {boolean} Whether condition was met
 */
function waitForCondition(condition, timeout, interval, multiplier) {
  var startTime = new Date().getTime();
  var endTime = startTime + timeout;
  var currentInterval = interval || 1000;
  var backoffMultiplier = multiplier || 1.5;
  var maxInterval = 10000; // Maximum interval of 10 seconds
  
  while (new Date().getTime() < endTime) {
    try {
      if (condition()) {
        return true;
      }
    } catch (e) {
      // Continue waiting
    }
    
    java.lang.Thread.sleep(currentInterval);
    
    // Exponential backoff
    currentInterval = Math.min(currentInterval * backoffMultiplier, maxInterval);
  }
  
  return false;
}

/**
 * Enhanced retry mechanism with exponential backoff
 * @param {function} operation - Operation to retry
 * @param {number} maxRetries - Maximum number of retries
 * @param {number} initialDelay - Initial delay in milliseconds
 * @param {number} multiplier - Backoff multiplier
 * @returns {object} Result of the operation
 */
function retryWithBackoff(operation, maxRetries, initialDelay, multiplier) {
  var retries = 0;
  var delay = initialDelay || 1000;
  var backoffMultiplier = multiplier || 2.0;
  var maxDelay = 10000; // Maximum delay of 10 seconds
  
  while (retries <= maxRetries) {
    try {
      var result = operation();
      if (result) {
        return result;
      }
    } catch (e) {
      karate.log('Retry attempt ' + retries + ' failed: ' + e.message);
    }
    
    if (retries < maxRetries) {
      java.lang.Thread.sleep(delay);
      delay = Math.min(delay * backoffMultiplier, maxDelay);
    }
    
    retries++;
  }
  
  throw new Error('Operation failed after ' + maxRetries + ' retries');
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
  generateSessionId: generateSessionId,
  generateUniqueId: generateUniqueId,
  generateTestData: generateTestData,
  validateSchema: validateSchema,
  cleanupTestData: cleanupTestData,
  waitForCondition: waitForCondition,
  retryWithBackoff: retryWithBackoff,
  formatErrorMessage: formatErrorMessage,
  extractData: extractData,
  compareArrays: compareArrays,
  generateAuthHeaders: generateAuthHeaders,
  validateResponseTime: validateResponseTime,
  logTestExecution: logTestExecution
};

