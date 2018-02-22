package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

/**
 * Captures the data for each test suite result as returned by invoking the REST endpoint with
 * "func=run" and "suite=(name)" and "tests=(modules)".
 *
 * The "xml" field is intended to capture the XML that the endpoint returned.
 */
public class TestSuiteResult {

	private String xml;
	private String name;
	private int total;
	private int passed;
	private int failed;
	private double time;
	private List<TestResult> testResults = new ArrayList<>();

	public TestSuiteResult(String xml, String name, int total, int passed, int failed, double time) {
		this.xml = xml;
		this.name = name;
		this.total = total;
		this.passed = passed;
		this.failed = failed;
		this.time = time;
	}

	public void addTestResult(TestResult testResult) {
		if (testResults == null) {
			testResults = new ArrayList<>();
		}
		testResults.add(testResult);
	}

	@Override
	public String toString() {
		return String.format("[name: %s, total: %d, passed: %d, failed: %d, time: %f, results: %s]",
			name, total, passed, failed, time, testResults);
	}

	public String getName() {
		return name;
	}

	public int getTotal() {
		return total;
	}

	public int getPassed() {
		return passed;
	}

	public int getFailed() {
		return failed;
	}

	public double getTime() {
		return time;
	}

	public List<TestResult> getTestResults() {
		return testResults;
	}

	public String getXml() {
		return xml;
	}
}
