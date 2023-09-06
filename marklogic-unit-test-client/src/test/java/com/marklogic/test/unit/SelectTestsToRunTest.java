package com.marklogic.test.unit;

import org.junit.jupiter.api.Test;

import java.util.Arrays;
import java.util.List;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

public class SelectTestsToRunTest {

    @Test
    void selectTestsInSuite() {
        JUnitTestSuite suite = new TestManager(ClientUtil.getClient())
            .runSuite("Assertions", new TestManager.RunParameters("assert-all-exist.xqy", "assert-equal.xqy"));

        // Simple check to verify that the XML is pretty-printed for easier manual inspection.
        final String xml = suite.getXml();
        final String message = "Expecting each testcase to be indented with 2 spaces; actual XML: " + xml;
        assertTrue(xml.contains("  <testcase classname=\"assert-all-exist.xqy\""), message);
        assertTrue(xml.contains("  <testcase classname=\"assert-equal.xqy\""), message);

        assertEquals("Assertions", suite.getName());
        assertEquals(2, suite.getTestCases().size());
        assertFalse(suite.hasTestFailures());
        assertEquals(0, suite.getErrors());
        assertEquals(0, suite.getFailures());
        assertEquals(21, suite.getTests(), "This should really be called 'assertions', as marklogic-unit-test " +
            "is measuring the number of successful test assertions returned by a non-failed test. The two " +
            "selected test modules together contain 21 successful assertions.");

        List<JUnitTestCase> testCases = suite.getTestCases();
        assertEquals("assert-all-exist.xqy", testCases.get(0).getName());
        assertEquals("assert-equal.xqy", testCases.get(1).getName());
    }

    @Test
    void selectSubsetOfSuites() {
        TestManager mgr = new TestManager(ClientUtil.getClient());
        TestManager.RunParameters params = new TestManager.RunParameters();

        List<JUnitTestSuite> suites = mgr.runSuites(Arrays.asList("Assertions", "Helpers"), params);

        assertEquals(2, suites.size());
        assertEquals("Assertions", suites.get(0).getName());
        assertFalse(suites.get(0).hasTestFailures());
        assertEquals("Helpers", suites.get(1).getName());
        assertFalse(suites.get(1).hasTestFailures());
    }
}
