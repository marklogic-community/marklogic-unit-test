package com.marklogic.test.unit;

import com.marklogic.client.DatabaseClient;
import com.marklogic.client.extensions.ResourceManager;
import com.marklogic.client.io.StringHandle;
import com.marklogic.client.io.marker.AbstractWriteHandle;
import com.marklogic.client.util.RequestParameters;

import java.util.ArrayList;
import java.util.List;

/**
 * Provides methods for talking to the ml-unit-test REST extension.
 */
public class TestManager extends ResourceManager {

	private ServiceResponseUnmarshaller unitTestXmlParser;

	public TestManager(DatabaseClient client) {
		this(client, new JaxpServiceResponseUnmarshaller());
	}

	public TestManager(DatabaseClient client, ServiceResponseUnmarshaller unitTestXmlParser) {
		super();
		this.unitTestXmlParser = unitTestXmlParser;
		client.init("ml-unit-test", this);
	}

	/**
	 * @return one TestModule for each test module found in the modules database
	 */
	public List<TestModule> list() {
		RequestParameters params = new RequestParameters();
		params.add("func", "list");
		String xml = getServices().get(params, new StringHandle()).get();
		return unitTestXmlParser.parseTestList(xml);
	}

	/**
	 * @return the distinct set of suite names in all of the test modules
	 */
	public List<String> listSuites() {
		List<TestModule> testModules = list();
		List<String> suites = new ArrayList<>();
		for (TestModule testModule : testModules) {
			String suite = testModule.getSuite();
			if (!suites.contains(suite)) {
				suites.add(suite);
			}
		}
		return suites;
	}

	/**
	 * Run a single test module. This is intended to be used in a parameterized JUnit test, where each test
	 * module is intended to correspond to a separate JUnit test.
	 *
	 * @param testModule
	 * @return
	 */
	public TestSuiteResult run(TestModule testModule) {
		RequestParameters params = new RequestParameters();
		params.add("func", "run");
		params.add("suite", testModule.getSuite());

		String test = testModule.getTest();
		if (test != null) {
			params.add("tests", testModule.getTest());
		}

		String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
		return unitTestXmlParser.parseTestSuiteResult(xml);
	}

	/**
	 * @return a JUnitTestSuite for every suite found in the modules database
	 */
	public List<JUnitTestSuite> runAllSuites() {
		List<String> suiteNames = listSuites();
		List<JUnitTestSuite> suites = new ArrayList<>();
		for (String suiteName : suiteNames) {
			suites.add(runSuite(suiteName));
		}
		return suites;
	}

	/**
	 * @param suite
	 * @return a JUnitTestSuite capturing the results of running the given suite name
	 */
	public JUnitTestSuite runSuite(String suite) {
		return runSuite(suite, true, true);
	}

	public JUnitTestSuite runSuite(String suite, boolean runTeardown, boolean runSuiteTeardown) {
		RequestParameters params = new RequestParameters();
		params.add("func", "run");
		params.add("suite", suite);
		params.add("format", "junit");
		params.add("runsuiteteardown", String.valueOf(runSuiteTeardown));
		params.add("runteardown", String.valueOf(runTeardown));
		String xml = getServices().post(params, (AbstractWriteHandle) null, new StringHandle()).get();
		return unitTestXmlParser.parseJUnitTestSuiteResult(xml);
	}

	public void setUnitTestXmlParser(ServiceResponseUnmarshaller unitTestXmlParser) {
		this.unitTestXmlParser = unitTestXmlParser;
	}
}
