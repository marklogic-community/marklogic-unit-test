package com.marklogic.test.unit;

/**
 * Captures the result for a running a single test. failureXml will be populated if the test failed. Does not yet
 * capture the number of successful assertions, just whether or not the test succeeded.
 */
public class TestResult {

	private String name;
	private double time;
  private int tests;
  private int success;
  private int failed;
	private String failureXml;

	public TestResult(String name, double time, int tests, int success, int failed, String failureXml) {
		this.name = name;
		this.time = time;
    this.tests = tests;
    this.success = success;
    this.failed = failed;
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

  public int getTests() {
    return tests;
  }

  public int getSuccess() {
    return success;
  }

  public int getFailed() {
    return failed;
  }

  public String getFailureXml() {
		return failureXml;
	}
}
