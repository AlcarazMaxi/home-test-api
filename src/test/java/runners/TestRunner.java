package runners;

import com.intuit.karate.junit5.Karate;
import org.junit.jupiter.api.Test;

/**
 * Test runner class for executing Karate tests
 * Provides different test execution strategies and configurations
 */
public class TestRunner {
    
    /**
     * Run all smoke tests
     * Executes tests tagged with @smoke
     */
    @Test
    public void runSmokeTests() {
        Karate.run("classpath:features")
            .tags("@smoke")
            .relativeTo(getClass());
    }
    
    /**
     * Run all regression tests
     * Executes tests tagged with @regression
     */
    @Test
    public void runRegressionTests() {
        Karate.run("classpath:features")
            .tags("@regression")
            .relativeTo(getClass());
    }
    
    /**
     * Run all tests
     * Executes all tests regardless of tags
     */
    @Test
    public void runAllTests() {
        Karate.run("classpath:features")
            .relativeTo(getClass());
    }
    
    /**
     * Run inventory tests only
     * Executes tests in inventory.feature file
     */
    @Test
    public void runInventoryTests() {
        Karate.run("classpath:features/inventory.feature")
            .relativeTo(getClass());
    }
    
    /**
     * Run negative tests only
     * Executes tests in inventory-negative.feature file
     */
    @Test
    public void runNegativeTests() {
        Karate.run("classpath:features/inventory-negative.feature")
            .relativeTo(getClass());
    }
    
    /**
     * Run tests with specific environment
     * Executes tests with environment-specific configuration
     */
    @Test
    public void runTestsWithEnvironment() {
        String environment = System.getProperty("karate.env", "dev");
        Karate.run("classpath:features")
            .tags("@smoke")
            .systemProperty("karate.env", environment)
            .relativeTo(getClass());
    }
    
    /**
     * Run tests with parallel execution
     * Executes tests in parallel for faster execution
     */
    @Test
    public void runTestsInParallel() {
        Karate.run("classpath:features")
            .tags("@smoke")
            .relativeTo(getClass())
            .parallel(4);
    }
    
    /**
     * Run tests with specific output directory
     * Executes tests and saves reports to specified directory
     */
    @Test
    public void runTestsWithOutput() {
        Karate.run("classpath:features")
            .tags("@smoke")
            .outputCucumberJson(true)
            .outputJunitXml(true)
            .relativeTo(getClass());
    }
}

