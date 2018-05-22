package com.marklogic.test.unit;

/**
 * Captures the result for a running a single test. failureXml will be populated if the test failed. Does not yet
 * capture the number of successful assertions, just whether or not the test succeeded.
 */
public class TestResult {

	private String name;
	private double time;
	private String failureXml;

	public TestResult(String name, double time, String failureXml) {
		this.name = name;
		this.time = time;
		this.failureXml = failureXml;
	}

	@Override
	public String toString() {
		return String.format("[name: %s, time: %f, failureXml: %s]", name, time, failureXml);
	}

	public String getName() {
		return name;
	}

	public double getTime() {
		return time;
	}

	public String getFailureXml() {
		return failureXml;
	}
}
