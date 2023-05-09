package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

/**
 * Captures the data returned for each test case. The "testFailures" field is modeled as a List in case
 * multiple failures can ever be returned, but currently it's either empty or has one error.
 */
public class JUnitTestCase {

	private final String classname;
	private final String name;
	private final double time;

  private final int tests;

  private final int success;

  private final int fail;

	private List<JUnitTestFailure> testFailures;
  private List<JUnitTestCoverage> testCoverages;

	public JUnitTestCase(String name, String classname, double time, int tests, int success, int fail) {
		this.name = name;
		this.classname = classname;
		this.time = time;
    this.tests = tests;
    this.success = success;
    this.fail = fail;
	}

	public void addTestFailure(JUnitTestFailure testFailure) {
		if (testFailures == null) {
			testFailures = new ArrayList<>();
		}
		testFailures.add(testFailure);
	}

	public boolean hasTestFailures() {
		return testFailures != null && !testFailures.isEmpty();
	}

  public void addTestCoverage(JUnitTestCoverage testCoverage) {
    if (testCoverages == null) {
      testCoverages = new ArrayList<>();
    }
    testCoverages.add(testCoverage);
  }

  public boolean hasTestCoverages() {
    return testCoverages != null && !testCoverages.isEmpty();
  }

	@Override
	public String toString() {
		return String.format("[name: %s, classname: %s, time: %f, testFailures: %s, testCoverages: %s]",
			name, classname, time, testFailures, testCoverages);
	}

	public String getClassname() {
		return classname;
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

  public int getFail() {
    return fail;
  }

  public List<JUnitTestFailure> getTestFailures() {
		return testFailures;
	}

	public void setTestFailures(List<JUnitTestFailure> testFailures) {
		this.testFailures = testFailures;
	}

  public List<JUnitTestCoverage> getTestCoverages() {
    return testCoverages;
  }
}
