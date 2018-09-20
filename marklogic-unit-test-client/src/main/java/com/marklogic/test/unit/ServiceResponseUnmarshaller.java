package com.marklogic.test.unit;

import java.util.List;

/**
 * Defines how the XML responses from the REST endpoint are unmarshalled into Java objects that are easily
 * integrated into Java testing frameworks.
 */
public interface ServiceResponseUnmarshaller {

	List<TestModule> parseTestList(String xml);

	TestSuiteResult parseTestSuiteResult(String xml);

	JUnitTestSuite parseJUnitTestSuiteResult(String xml);
}
