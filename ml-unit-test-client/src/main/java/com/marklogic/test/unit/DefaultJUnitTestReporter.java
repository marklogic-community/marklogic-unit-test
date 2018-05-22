package com.marklogic.test.unit;

import java.util.List;

/**
 * Default implementation that is fairly similar to how the Gradle "test" task reports errors.
 */
public class DefaultJUnitTestReporter implements JUnitTestReporter {

	@Override
	public String reportOnJUnitTestSuites(List<JUnitTestSuite> suites) {
		StringBuilder sb = new StringBuilder();

		int testsCompleted = 0;
		int testFailed = 0;

		for (JUnitTestSuite suite : suites) {
			if (suite.getTestCases() == null) {
				continue;
			}
			for (JUnitTestCase testCase : suite.getTestCases()) {
				testsCompleted++;
				if (testCase.hasTestFailures()) {
					testFailed++;
					sb.append("\n\n" + testCase.getClassname() + " > " + testCase.getName() + " FAILED");
					for (JUnitTestFailure failure : testCase.getTestFailures()) {
						sb.append("\n    " + failure.getMessage());
					}
				}
			}
		}
		sb.append("\n\n" + testsCompleted + " tests completed, " + testFailed + " failed");
		return sb.toString();
	}
}
