package runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

/**
 * Karate test runner for Inventory API tests.
 * This runner executes the inventory-api.feature file
 * to validate all required API test scenarios.
 */
class InventoryTestRunner {

    /**
     * Runs the inventory API feature file.
     * This method executes all test scenarios defined in inventory-api.feature
     * including GET /api/inventory, filtering, and POST operations.
     */
    @Test
    void testInventoryAPI() {
        Karate.run("classpath:features/inventory-api.feature")
              .relativeTo(getClass());
    }
}
