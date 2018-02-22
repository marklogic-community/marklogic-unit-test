package com.marklogic.test.unit;

import java.util.ArrayList;
import java.util.List;

/**
 * Captures the data returned for each test case. The "testFailures" field is modeled as a List in case
 * multiple failures can ever be returned, but currently it's either empty or has one error.
 */
public class JUnitTestCase {

	private String classname;
	private String name;
	private double time;
	private List<JUnitTestFailure> testFailures;

	public JUnitTestCase(String name, String classname, double time) {
		this.name = name;
		this.classname = classname;
		this.time = time;
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

	@Override
	public String toString() {
		return String.format("[name: %s, classname: %s, time: %f, testFailures: %s]",
			name, classname, time, testFailures);
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

	public List<JUnitTestFailure> getTestFailures() {
		return testFailures;
	}

	public void setTestFailures(List<JUnitTestFailure> testFailures) {
		this.testFailures = testFailures;
	}
}
