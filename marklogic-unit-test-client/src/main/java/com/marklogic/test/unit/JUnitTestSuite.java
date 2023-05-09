package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents the XML returned when the requested format is "junit". The "xml" field is intended to
 * hold the XML that was returned so that it can be e.g. written to a file if desired.
 */
public class JUnitTestSuite {

	private final String xml;
	private final int errors;
	private final int failures;
	private final String hostname;
	private final String name;
	private final int tests;
	private final double time;
  private final int cases;

	private List<JUnitTestCase> testCases;

	public JUnitTestSuite(String xml, int errors, int failures, String hostname, String name, int cases, int tests, double time) {
		this.xml = xml;
		this.errors = errors;
		this.failures = failures;
		this.hostname = hostname;
		this.name = name;
		this.tests = tests;
		this.time = time;
    this.cases = cases;
	}

	public void addTestCase(JUnitTestCase testCase) {
		if (testCases == null) {
			testCases = new ArrayList<>();
		}
		testCases.add(testCase);
	}

	public boolean hasTestFailures() {
		if (testCases == null) {
			return false;
		}
		for (JUnitTestCase testCase : testCases) {
			if (testCase.hasTestFailures()) {
				return true;
			}
		}
		return false;
	}

	@Override
	public String toString() {
		return String.format("[name: %s, tests: %d, cases: %d, errors: %d, failures: %d, hostname: %s, time: %f, testCases: %s]",
			name, tests, cases, errors, failures, hostname, time, testCases);
	}

	public int getErrors() {
		return errors;
	}

	public int getFailures() {
		return failures;
	}

	public String getHostname() {
		return hostname;
	}

	public String getName() {
		return name;
	}

	public int getTests() {
		return tests;
	}

	public double getTime() {
		return time;
	}

	public List<JUnitTestCase> getTestCases() {
		return testCases;
	}

	public String getXml() {
		return xml;
	}

  public int getCases() {
    return cases;
  }
}
