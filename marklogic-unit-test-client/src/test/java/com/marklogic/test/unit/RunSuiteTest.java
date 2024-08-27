package com.marklogic.test.unit;

import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;

/**
 * Example of how all the test suites can be run by themselves, e.g. as part of a custom Gradle task.
 */
public class RunSuiteTest {

    @Test
    public void test() {
        List<JUnitTestSuite> suites = new TestManager(ClientUtil.getClient()).runAllSuites();
        String report = new DefaultJUnitTestReporter().reportOnJUnitTestSuites(suites);
        assertEquals("45 tests completed, 0 failed", report.trim());
    }
}
