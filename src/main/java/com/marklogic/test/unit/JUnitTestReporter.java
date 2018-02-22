package com.marklogic.test.unit;

import java.util.List;

/**
 * Strategy interface for generating a String representation of a bunch of JUnitTestSuite's. Initial use case is for
 * printing the String out to stdout as part of a Gradle task.
 */
public interface JUnitTestReporter {

	String reportOnJUnitTestSuites(List<JUnitTestSuite> suites);
}
