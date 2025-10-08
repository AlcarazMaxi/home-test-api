package runners;

import com.intuit.karate.Results;
import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

/**
 * Simple test runner to avoid timeout issues
 * Runs basic API tests without complex configuration
 */
public class SimpleTestRunner {

    @Test
    public void testInventoryAPI() {
        // Simple test configuration
        Results results = Runner.path("classpath:features")
                .tags("@smoke")
                .parallel(1); // Single thread to avoid complexity
        
        // Assert all tests passed
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
