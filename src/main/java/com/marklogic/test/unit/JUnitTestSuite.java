package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

/**
 * Represents the XML returned when the requested format is "junit". The "xml" field is intended to
 * hold the XML that was returned so that it can be e.g. written to a file if desired.
 */
public class JUnitTestSuite {

	private String xml;
	private int errors;
	private int failures;
	private String hostname;
	private String name;
	private int tests;
	private double time;
	private List<JUnitTestCase> testCases;

	public JUnitTestSuite(String xml, int errors, int failures, String hostname, String name, int tests, double time) {
		this.xml = xml;
		this.errors = errors;
		this.failures = failures;
		this.hostname = hostname;
		this.name = name;
		this.tests = tests;
		this.time = time;
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
		return String.format("[name: %s, tests: %d, errors: %d, failures: %d, hostname: %s, time: %f, testCases: %s]",
			name, tests, errors, failures, hostname, time, testCases);
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
}
