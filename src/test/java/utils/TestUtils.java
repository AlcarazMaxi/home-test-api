package utils;

import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Map;
import java.util.List;
import java.util.HashMap;
import java.util.ArrayList;
import java.util.Random;

/**
 * Utility class for test automation
 * Provides common helper methods for API testing
 */
public class TestUtils {
    
    private static final Random random = new Random();
    
    /**
     * Generate random test data
     * @param type - Type of data to generate
     * @return Generated data
     */
    public static String generateTestData(String type) {
        long timestamp = System.currentTimeMillis();
        
        switch (type.toLowerCase()) {
            case "id":
                return String.valueOf(random.nextInt(1000) + timestamp);
            case "name":
                return "Test Item " + timestamp;
            case "price":
                return String.format("%.2f", random.nextDouble() * 100 + 1);
            case "email":
                return "test" + timestamp + "@example.com";
            default:
                return "test" + timestamp;
        }
    }
    
    /**
     * Generate random number within range
     * @param min - Minimum value
     * @param max - Maximum value
     * @return Random number
     */
    public static int generateRandomNumber(int min, int max) {
        return random.nextInt(max - min + 1) + min;
    }
    
    /**
     * Generate random string
     * @param length - String length
     * @return Random string
     */
    public static String generateRandomString(int length) {
        String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < length; i++) {
            sb.append(chars.charAt(random.nextInt(chars.length())));
        }
        return sb.toString();
    }
    
    /**
     * Generate test item data
     * @return Map containing test item data
     */
    public static Map<String, Object> generateTestItem() {
        Map<String, Object> item = new HashMap<>();
        item.put("id", generateRandomNumber(1, 1000));
        item.put("name", "Test Item " + System.currentTimeMillis());
        item.put("price", Double.parseDouble(generateTestData("price")));
        item.put("image", "test-image-" + System.currentTimeMillis() + ".jpg");
        return item;
    }
    
    /**
     * Generate invalid test item data
     * @return Map containing invalid test item data
     */
    public static Map<String, Object> generateInvalidTestItem() {
        Map<String, Object> item = new HashMap<>();
        item.put("id", "invalid");
        item.put("name", "");
        item.put("price", -10.99);
        item.put("image", "");
        return item;
    }
    
    /**
     * Validate JSON structure
     * @param json - JSON string to validate
     * @param requiredFields - Array of required field names
     * @return True if JSON has all required fields
     */
    @SuppressWarnings("unchecked")
    public static boolean validateJsonStructure(String json, String[] requiredFields) {
        try {
            ObjectMapper mapper = new ObjectMapper();
            Map<String, Object> data = mapper.readValue(json, Map.class);
            for (String field : requiredFields) {
                if (!data.containsKey(field)) {
                    return false;
                }
            }
            return true;
        } catch (Exception e) {
            return false;
        }
    }
    
    /**
     * Validate field types
     * @param data - Data map to validate
     * @param fieldTypes - Map of field names to expected types
     * @return True if all fields have correct types
     */
    public static boolean validateFieldTypes(Map<String, Object> data, Map<String, String> fieldTypes) {
        for (Map.Entry<String, String> entry : fieldTypes.entrySet()) {
            String field = entry.getKey();
            String expectedType = entry.getValue();
            Object value = data.get(field);
            
            if (value == null) {
                return false;
            }
            
            switch (expectedType.toLowerCase()) {
                case "number":
                    if (!(value instanceof Number)) {
                        return false;
                    }
                    break;
                case "string":
                    if (!(value instanceof String)) {
                        return false;
                    }
                    break;
                case "boolean":
                    if (!(value instanceof Boolean)) {
                        return false;
                    }
                    break;
                default:
                    return false;
            }
        }
        return true;
    }
    
    /**
     * Format error message
     * @param expected - Expected value
     * @param actual - Actual value
     * @return Formatted error message
     */
    public static String formatErrorMessage(String expected, String actual) {
        return String.format("Expected: %s, Actual: %s", expected, actual);
    }
    
    /**
     * Get current timestamp
     * @return Current timestamp string
     */
    public static String getCurrentTimestamp() {
        return String.valueOf(System.currentTimeMillis());
    }
    
    /**
     * Sleep for specified duration
     * @param milliseconds - Milliseconds to sleep
     */
    public static void sleep(long milliseconds) {
        try {
            Thread.sleep(milliseconds);
        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
        }
    }
    
    /**
     * Check if string is numeric
     * @param str - String to check
     * @return True if string is numeric
     */
    public static boolean isNumeric(String str) {
        try {
            Double.parseDouble(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Check if string is integer
     * @param str - String to check
     * @return True if string is integer
     */
    public static boolean isInteger(String str) {
        try {
            Integer.parseInt(str);
            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
    
    /**
     * Generate test data for different scenarios
     * @param scenario - Test scenario name
     * @return Map containing test data for scenario
     */
    public static Map<String, Object> generateScenarioData(String scenario) {
        Map<String, Object> data = new HashMap<>();
        
        switch (scenario.toLowerCase()) {
            case "valid":
                data.put("id", generateRandomNumber(1, 1000));
                data.put("name", "Valid Item");
                data.put("price", 29.99);
                data.put("image", "valid-image.jpg");
                break;
            case "invalid":
                data.put("id", "invalid");
                data.put("name", "");
                data.put("price", -10.99);
                data.put("image", "");
                break;
            case "edge":
                data.put("id", 0);
                data.put("name", "a".repeat(1000));
                data.put("price", 0.01);
                data.put("image", "edge-image.jpg");
                break;
            default:
                data.put("id", 1);
                data.put("name", "Default Item");
                data.put("price", 10.00);
                data.put("image", "default-image.jpg");
        }
        
        return data;
    }
    
    /**
     * Create test data list
     * @param count - Number of test items to create
     * @return List of test items
     */
    public static List<Map<String, Object>> createTestDataList(int count) {
        List<Map<String, Object>> items = new ArrayList<>();
        for (int i = 0; i < count; i++) {
            items.add(generateTestItem());
        }
        return items;
    }
    
    /**
     * Validate response time
     * @param responseTime - Response time in milliseconds
     * @param maxTime - Maximum allowed time
     * @return True if response time is acceptable
     */
    public static boolean validateResponseTime(long responseTime, long maxTime) {
        return responseTime <= maxTime;
    }
    
    /**
     * Generate unique identifier
     * @return Unique identifier string
     */
    public static String generateUniqueId() {
        return "test_" + System.currentTimeMillis() + "_" + random.nextInt(1000);
    }
}
