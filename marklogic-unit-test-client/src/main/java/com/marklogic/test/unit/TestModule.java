package com.marklogic.test.unit;

/**
 * Captures the data for each test module returned by invoking the REST endpoint with "func=list".
 */
public class TestModule {

	private final String test;
	private final String suite;

	public TestModule(String test, String suite) {
		this.test = test;
		this.suite = suite;
	}

	@Override
	public String toString() {
		return String.format("[suite: %s, test: %s]", suite, test);
	}

	public String getTest() {
		return test;
	}

	public String getSuite() {
		return suite;
	}
}
